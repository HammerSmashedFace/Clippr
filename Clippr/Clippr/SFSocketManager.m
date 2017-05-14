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
	
	[socket once:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		NSLog(@"socket connected");
	}];
	
	[socket connect];
	self.socket = socket;
	[socket emit:@"history" with:@[]];
	
	[socket once:@"disconnect" callback:^(NSArray * _Nonnull array, SocketAckEmitter * _Nonnull emitter)
	{
		[socket removeAllHandlers];
		[self connect];
	}];
}

- (void)copyItem:(SFClipboardItem *)item
{
	[self.socket emit:@"copy_text" with:@[item.dictionaryRepresentation]];
}

- (void)getHistoryWithCompletionBlock:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))completionBlock
{
	[self.socket emit:@"history" with:@[]];
	[self.socket once:@"history" callback:completionBlock];
}

- (void)getMessageWithCompletionBlock:(void (^)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))completionBlock
{
	[self.socket once:@"copy_text" callback:completionBlock];
}

@end
