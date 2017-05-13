//
//  HSFEventManager.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFEventManager.h"
#import "HSFDataController.h"
#import "HSFClipboardItem.h"

#import <SocketIO/Socket.IO-Client-Swift-umbrella.h>

static NSString *const kHSFEventManagerSocketURL = @"http://crowley-m-pc.zeo.lcl:3000";

@interface HSFEventManager () <HSFDataControllerDelegate>

@property (nonatomic, strong, readwrite) SocketIOClient *socketClient;
@property (nonatomic, assign, readwrite, getter=isConnected) BOOL connected;

@end

@implementation HSFEventManager

- (instancetype)init
{
	self = [super init];

	if (self != nil)
	{
		NSURL *socketURL = [NSURL URLWithString:kHSFEventManagerSocketURL];
		_connected = NO;
		_socketClient = [[SocketIOClient alloc] initWithSocketURL:socketURL config:@{@"log": @YES, @"forcePolling": @YES}];

		[_socketClient connect];
	}

	return self;
}

- (void)dealloc
{
	[self.socketClient disconnect];
}

- (void)configureSocket
{
	[self.socketClient on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		self.connected = YES;
		[self.socketClient emit:@"history" with:@[]];
		NSLog(@"socket connected");
	}];

	[self.socketClient on:@"copy_text" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		if (self.connected && [data.firstObject isKindOfClass:[NSDictionary class]])
		{
			[self.delegate eventManager:self didReceiveData:data.firstObject];
		}
	}];

	[self.socketClient on:@"history" callback:^(NSArray *date, SocketAckEmitter *ack)
	{
		if (self.connected)
		{
			NSLog(@"%@", date);
		}
	}];
}

#pragma mark - HSFDataControllerDelegate

- (void)dataControllerDidReceiveFetch:(HSFDataController *)controller
{
	if (self.connected)
	{
		[self.socketClient emit:@"history" with:@[]];
	}
}

- (void)dataController:(HSFDataController *)controller didReceiveItem:(HSFClipboardItem *)item
{
	if (self.connected)
	{
		[self.socketClient emit:@"copy_text" with:@[ [item jsonRepresentation] ]];
	}
}

@end
