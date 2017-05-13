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

static NSString *const kHSFEventManagerSocketURL = @"crowley-m-pc.zeo.lcl:3000";

@interface HSFEventManager () <HSFDataControllerDelegate>

@property (nonatomic, strong, readwrite) SocketIOClient *socketClient;

@end

@implementation HSFEventManager

- (instancetype)init
{
	self = [super init];

	if (self != nil)
	{
		NSURL *socketURL = [NSURL URLWithString:kHSFEventManagerSocketURL];
		_socketClient = [[SocketIOClient alloc] initWithSocketURL:socketURL config:@{@"log": @YES, @"forcePolling": @YES}];

		[_socketClient connect];
	}

	return self;
}

- (void)configureSocket
{
	[self.socketClient on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		NSLog(@"socket connected");
	}];

	[self.socketClient on:@"copy_text" callback:^(NSArray *data, SocketAckEmitter *ack)
	{
		if ([data.firstObject isKindOfClass:[NSDictionary class]])
		{
			[self.delegate eventManager:self didReceiveData:data.firstObject];
		}
	}];
}

- (void)dataController:(HSFDataController *)controller didReceiveItem:(HSFClipboardItem *)item
{
	[self.socketClient emit:@"copy_text" with:@[ [item jsonRepresentation] ]];
}

@end
