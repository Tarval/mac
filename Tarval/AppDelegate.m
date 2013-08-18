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
    self.statusItem.title = @"T";
    self.statusItem.target = self;
    [self.statusItem setAction:@selector(clickStatusBar:)];
}

- (void)clickStatusBar:(id)sender
{
    self.window.isVisible = !self.window.isVisible;
}

@end
