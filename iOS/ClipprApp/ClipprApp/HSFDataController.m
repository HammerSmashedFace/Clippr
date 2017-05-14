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

@property (nonatomic, copy, readwrite) NSMutableArray<HSFClipboardItem *> *mutableItems;

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

#pragma mark -

- (void)addItem:(HSFClipboardItem *)item
{
	[self.delegate dataController:self didReceiveItem:item];
}

- (void)fetchItems
{
	[self.delegate dataControllerDidReceiveFetch:self];
}

#pragma mark - HSFJSONManagerDelegate

- (void)jsonManager:(HSFJSONManager *)manager didUpdateData:(NSArray *)data
{
	[self.mutableItems removeAllObjects];

	for (NSDictionary *itemDictionary in data)
	{		
		HSFClipboardItem *newItem = [[HSFClipboardItem alloc] initWithJSONRepresentation:itemDictionary];

		[self willChangeValueForKey:@"items"];
		[self.mutableItems addObject:newItem];
		[self didChangeValueForKey:@"items"];
	}
}

- (void)jsonManager:(HSFJSONManager *)manager didReceiveItem:(NSDictionary *)data
{	
	HSFClipboardItem *newItem = [[HSFClipboardItem alloc] initWithJSONRepresentation:data];

	[self willChangeValueForKey:@"items"];
	[self.mutableItems addObject:newItem];
	[self didChangeValueForKey:@"items"];
}

@end
