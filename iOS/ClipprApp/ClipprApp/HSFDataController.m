//
//  HSFDataController.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFDataController.h"
#import "HSFJSONManager.h"
#import "HSFEventManager.h"

@interface HSFDataController () <HSFJSONManagerDelegate>

@property (nonatomic, copy, readonly) NSMutableArray<HSFClipboardItem *> *mutableItems;
@property (nonatomic, weak, readwrite) HSFEventManager *eventManager;

@end

@implementation HSFDataController

- (instancetype)init
{
	self = [super init];

	if (self != nil)
	{
		_mutableItems = [[NSMutableArray alloc] init];
	}

	return self;
}

- (NSArray<HSFClipboardItem *> *)items
{
	return [_mutableItems copy];
}

- (void)addItem:(HSFClipboardItem *)item
{
	[self.delegate dataController:self didReceiveItem:item];
}

- (void)fetchItems
{
	[self.delegate dataControllerDidReceiveFetch:self];
}

#pragma mark - HSFJSONManagerDelegate

- (void)jsonManager:(HSFJSONManager *)manager didUpdateData:(NSDictionary *)data
{
	HSFClipboardItem *newItem = [[HSFClipboardItem alloc] initWithJSONRepresentation:data];
	[self.mutableItems addObject:newItem];
}

@end
