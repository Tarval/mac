//
//  PreferencesController.h
//  Tarval
//
//  Created by Steve Gattuso on 8/17/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebsocketMC.h"

@interface PreferencesController : NSObject<NSTextFieldDelegate> {
    // I hate that I'm doing it this way. MOAR IBOutletCollection
    IBOutlet NSTextField *pinFieldZero;
    IBOutlet NSTextField *pinFieldOne;
    IBOutlet NSTextField *pinFieldTwo;
    IBOutlet NSTextField *pinFieldThree;
    
    NSArray *pinFields;
    
    IBOutlet NSProgressIndicator *loadingIndicator;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSImageView *checkImage;
    
    WebsocketMC *websocketMC;
}

- (void)finishEnteringPin;
- (void)websocketPinBound: (NSNotification*)notification;
- (void)websocketOpened: (NSNotification*)notification;
- (void)websocketClosed: (NSNotification*)notification;
- (void)websocketFailed: (NSNotification*)notification;

@end
