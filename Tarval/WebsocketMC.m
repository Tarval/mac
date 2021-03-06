//
//  WebsocketMC.m
//  Tarval
//
//  Created by Steve Gattuso on 8/3/13.
//  Copyright (c) 2013 hackNY. All rights reserved.
//

#import "WebsocketMC.h"
#import "TRConstants.h"

@implementation WebsocketMC

@synthesize websocket;

-(void)connect
{
    self.websocket = [[SRWebSocket alloc] initWithURL:[TRConstants websocketEndpoint] protocols: [TRConstants websocketProtocol]];
    self.websocket.delegate = self;
    [self.websocket open];
    NSLog(@"Opening connection");
}

-(void)sendEvent: (NSString*)event_name data: (NSDictionary*)data
{
    NSMutableDictionary *send;
    if(data) {
        send = [data mutableCopy];
    } else {
        send = [[NSMutableDictionary alloc] init];
    }
    
    send[@"e"] = event_name;
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:send options:0 error:NULL];
    NSString *json_string = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    [self.websocket send: json_string];
}

-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Connection opened");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wsOpened" object:webSocket];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wsFailed" object:webSocket];
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Connection closed");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wsClosed" object:webSocket];
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString*)message
{
    NSError *error;
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    NSString *event_name = [[NSString alloc] initWithFormat:@"ws:%@", resp[@"e"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:event_name object:resp];
}

@end
