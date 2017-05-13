//
//  SFSocketManager.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFSocketManager.h"

@interface SFSocketManager()

@property (nonatomic, retain) SocketIOClient *socket;

@end

@implementation SFSocketManager

- (void)connect
{
	NSURL *url = [[NSURL alloc] initWithString:@"http://crowley-m-pc.zeo.lcl:3000"];
	SocketIOClient *socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
	
	[socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		NSLog(@"socket connected");
	}];
	
	[socket on:@"currentAmount" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		double cur = [[data objectAtIndex:0] floatValue];
		
		[[socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray *data)
		{
			[socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
		}];
		
		[ack with:@[@"Got your currentAmount, ", @"dude"]];
	}];
	
	[socket connect];
	self.socket = socket;
	[self.socket emit:@"history" with:@[]];
}

- (void)copyItem:(SFClipboardItem *)item
{
	[self.socket emit:@"copy_text" with:@[item.dictionaryRepresentation]];
}

- (void)getHistoryWithCompletionBlock:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))completionBlock
{
	[self.socket emit:@"history" with:@[]];
	[self.socket on:@"history" callback:completionBlock];
}

@end
