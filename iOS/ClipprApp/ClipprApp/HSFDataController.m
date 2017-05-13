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
	[_mutableItems sortUsingComparator:^NSComparisonResult(HSFClipboardItem *obj1, HSFClipboardItem *obj2)
	{
		if ([obj1.date laterDate:obj2.date])
		{
			return NSOrderedDescending;
		}
		else
		{
			return NSOrderedAscending;
		}
	}];

	return [_mutableItems copy];
}

//#pragma mark - Key Value Compliance
//
//- (NSUInteger)countOfMutableItems
//{
//	return self.mutableItems.count;
//}
//
//- (void)insertObject:(HSFClipboardItem *)object inMutableItemsAtIndex:(NSUInteger)index
//{
//	[self willChangeValueForKey:@"items"];
//	[self.mutableItems insertObject:object atIndex:index];
//	[self didChangeValueForKey:@"items"];
//}
//
//- (HSFClipboardItem *)objectInItemsAtIndex:(NSUInteger)index
//{
//	return [self.mutableItems objectAtIndex:index];
//}
//
//- (void)removeObjectFromMutableItemsAtIndex:(NSUInteger)index
//{
//	[self.mutableItems removeObjectAtIndex:index];
//}

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
//		[self insertObject:newItem inMutableItemsAtIndex:self.mutableItems.count];

		[self willChangeValueForKey:@"items"];
		[self.mutableItems addObject:newItem];
		[self didChangeValueForKey:@"items"];
	}
}

- (void)jsonManager:(HSFJSONManager *)manager didReceiveItem:(NSDictionary *)data
{
	HSFClipboardItem *newItem = [[HSFClipboardItem alloc] initWithJSONRepresentation:data];
//	[self insertObject:newItem inMutableItemsAtIndex:self.mutableItems.count];

	[self willChangeValueForKey:@"items"];
	[self.mutableItems addObject:newItem];
	[self didChangeValueForKey:@"items"];
}

@end
