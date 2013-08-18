//
//  AppDelegate.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebsocketMC.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    IBOutlet NSMenu *menu;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) WebsocketMC *websocket;
@property (strong, nonatomic) NSStatusItem *statusItem;

- (void)simulateKey:(NSInteger)key withPressValue:(BOOL)val;
- (NSInteger)translateKey: (NSNumber *)key;

- (IBAction)clickPreferences: (id)sender;
- (IBAction)clickQuit: (id)sender;

- (void)wsKeyDown: (NSNotification*)notification;
- (void)wsKeyUp: (NSNotification*)notification;
- (void)wsPhoneReady: (NSNotification*)notification;
- (void)wsPhoneClose: (NSNotification*)notification;

@end
