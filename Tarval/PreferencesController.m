//
//  PreferencesController.m
//  Tarval
//
//  Created by Steve Gattuso on 8/17/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "PreferencesController.h"
#import "AppDelegate.h"
#import "WebsocketMC.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

- (void) awakeFromNib
{
    // Set up the pin fields
    pinFields = @[pinFieldZero, pinFieldOne, pinFieldTwo, pinFieldThree];
    for(NSTextField *field in pinFields) {
        field.delegate = self;
    }
    [pinFieldZero.window makeFirstResponder:nil];
    
    AppDelegate *appDelegate = [NSApp delegate];
    websocketMC = appDelegate.websocket;
    
    // Update status of websocket
    if(websocketMC.websocket.readyState == SR_OPEN) {
        [self websocketOpened:nil];
    } else {
        [self websocketClosed:nil];
    }
    
    // Listen to notifications about the websocket status
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
      selector:@selector(websocketOpened:)
      name:@"wsOpened"
      object:nil];
    [notificationCenter addObserver:self
      selector:@selector(websocketClosed:)
      name:@"wsClosed"
      object:nil];
    [notificationCenter addObserver:self
      selector:@selector(websocketFailed:)
      name:@"wsFailed"
      object:nil];
    [notificationCenter addObserver:self
      selector:@selector(websocketPinBound:)
      name:@"ws:pinBound"
      object:nil];
}

# pragma mark Preferences window events
- (void) controlTextDidChange:(NSNotification *)notification
{
    NSTextField *sender = notification.object;
    NSInteger currentFieldIndex = [pinFields indexOfObject: sender];
    if(currentFieldIndex >= [pinFields count] - 1) {
        [self finishEnteringPin];
        [sender.window makeFirstResponder:nil];
        return;
    }
    
    // Select the next field
    NSTextField *nextField = [pinFields objectAtIndex:currentFieldIndex + 1];
    [nextField becomeFirstResponder];
}

- (void) finishEnteringPin
{
    [loadingIndicator setHidden: NO];
    [loadingIndicator startAnimation:nil];
    
    // Assemble the PIN from the text labels
    NSMutableString *pin = [[NSMutableString alloc] init];
    
    for(NSTextField *field in pinFields) {
        [pin appendString:field.stringValue];
        [field setEnabled: NO];
    }
    
    NSDictionary *send = @{
        @"pin": [NSNumber numberWithInt:(int)pin.integerValue]
    };
    [websocketMC sendEvent:@"bindPin" data:send];
    
    [repairButton setEnabled: YES];
}

- (IBAction)clickRepair: (id)sender
{
    // Reset the UI
    for(NSTextField *field in pinFields) {
        field.stringValue = @"";
        [field setEnabled: YES];
    }
    [repairButton setEnabled: NO];
    [checkImage setHidden: YES];
    [loadingIndicator setHidden: YES];
    
    [pinFields[0] becomeFirstResponder];
    [websocketMC sendEvent:@"unbindPin" data: nil];
}

# pragma mark Websocket events
- (void) websocketPinBound:(NSNotification *)notification
{
    [loadingIndicator setHidden: YES];
    [checkImage setHidden: NO];
}

- (void) websocketOpened:(NSNotification *)notification
{
    statusLabel.stringValue = @"Connected to server";
}

- (void) websocketClosed:(NSNotification *)notification
{
    statusLabel.stringValue = @"Disconnected";
}

- (void) websocketFailed:(NSNotification *)notification
{
    statusLabel.stringValue = @"Connection failed";
}

@end
