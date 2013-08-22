//
//  AppDelegate.m
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "AppDelegate.h"
#import "WebsocketMC.h"

@implementation AppDelegate

@synthesize websocket;
@synthesize statusItem;

- (id) init
{
    self = [super init];
    if(self) {
        // Let's connect to the Tarval server
        self.websocket = [[WebsocketMC alloc] init];
        [self.websocket connect];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Add the status bar item
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"controller_inactive"];
    self.statusItem.menu = menu;
    self.statusItem.highlightMode = YES;
    statusMenuItem.title = @"Status: Not connected";
    
    self.window.delegate = self;
    
    // Set up listeners
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
      selector:@selector(wsKeyDown:)
      name:@"ws:keyDown"
      object:nil];
    
    [notificationCenter addObserver:self
      selector:@selector(wsKeyUp:)
      name:@"ws:keyUp"
      object:nil];
    
    [notificationCenter addObserver:self
      selector:@selector(wsPhoneReady:)
      name:@"ws:phoneReady"
      object:nil];
    
    [notificationCenter addObserver:self
      selector:@selector(wsPhoneClose:)
      name:@"ws:phoneClose"
      object:nil];
}

# pragma mark NSWindowDelegate
- (BOOL)windowShouldClose:(id)sender
{
    self.window.isVisible = NO;
    return NO;
}

# pragma mark NSMenu events
- (IBAction)clickPreferences:(id)sender
{
    if(self.window.isVisible) {
        if(![self.window isMainWindow]) {
            [self.window makeKeyAndOrderFront:sender];
            [self.window setOrderedIndex:0];
            [NSApp activateIgnoringOtherApps:YES];
        } else {
            self.window.isVisible = NO;
        }
    } else {
        // TODO: Is all of this really needed?
        [self.window makeKeyAndOrderFront:sender];
        [self.window setOrderedIndex:0];
        [NSApp activateIgnoringOtherApps:YES];
        self.window.isVisible = YES;
    }
}

- (IBAction)clickQuit:(id)sender
{
    [NSApp terminate: self];
}

#pragma mark Keystroke methods
- (NSInteger)translateKey:(NSNumber *)key
{
    switch([key integerValue]) {
        // Return key
        case 13:
            return 0x24;
        // Left arrow
        case 37:
            return 0x7B;
        // Up arrow
        case 38:
            return 0x7E;
        // Right arrow
        case 39:
            return 0x7C;
        // Down arrow
        case 40:
            return 0x7D;
        // Space
        case 83:
            return 0x31;
    }
    
    return 0;
}

// True is down, false is up
- (void)simulateKey:(NSInteger)key withPressValue:(BOOL)val
{
    CGEventSourceRef src = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    CGEventRef eventRef = CGEventCreateKeyboardEvent(src, key, val);
    CGEventPost(kCGHIDEventTap, eventRef);
    CFRelease(src);
    CFRelease(eventRef);
}

#pragma mark Websocket notifications
- (void)wsKeyDown:(NSNotification *)notification
{
    NSNumber *key = notification.object[@"v"];
    NSInteger real = [self translateKey:key];
    
    [self simulateKey:real withPressValue:YES];
}

- (void)wsKeyUp:(NSNotification *)notification
{
    NSNumber *key = notification.object[@"v"];
    NSInteger real = [self translateKey:key];
    
    [self simulateKey:real withPressValue:NO];
}

- (void)wsPhoneReady:(NSNotification *)notification
{
    NSLog(@"Phone ready");
    statusMenuItem.title = @"Status: Connected";
    [self.statusItem setImage:[NSImage imageNamed:@"controller_active"]];
}

- (void)wsPhoneClose:(NSNotification *)notification
{
    NSLog(@"Phone closed");
    statusMenuItem.title = @"Status: Not connected";
    [self.statusItem setImage:[NSImage imageNamed:@"controller_inactive"]];
}
@end
