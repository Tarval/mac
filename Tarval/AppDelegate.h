//
//  AppDelegate.h
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebsocketMC.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) WebsocketMC *websocket;
@property (strong, nonatomic) NSStatusItem *statusItem;

- (void)clickStatusBar: (id)sender;

- (void)simulateKey:(NSInteger)key withPressValue:(BOOL)val;
- (NSInteger)translateKey: (NSNumber *)key;

- (void)wsKeyDown: (NSNotification*)notification;
- (void)wsKeyUp: (NSNotification*)notification;

@end
