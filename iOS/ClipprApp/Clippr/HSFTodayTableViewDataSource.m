//
//  HSFTodayTableViewDataSource.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFTodayTableViewDataSource.h"
#import "HSFClipboardItem.h"
#import "HSFModelController.h"

@implementation HSFTodayTableViewDataSource

- (NSArray<HSFClipboardItem *> *)items
{
	NSMutableArray *result = [NSMutableArray array];

	if (self.modelController.items.count != 0)
	{
		NSInteger itemsCount = self.modelController.items.count;
		NSInteger rangeLength = itemsCount > kHSFTodayViewControllerMaxItems ? kHSFTodayViewControllerMaxItems : itemsCount;
		NSInteger rangeLocation = itemsCount > kHSFTodayViewControllerMaxItems ? itemsCount - kHSFTodayViewControllerMaxItems : 0;
		NSRange indexesRange = NSMakeRange(rangeLocation, rangeLength);
		NSArray *rangedItems = [self.modelController.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexesRange]];

		NSSortDescriptor *sortDescripted = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
		[result addObjectsFromArray:[rangedItems sortedArrayUsingDescriptors:@[sortDescripted]]];
	}

	return result;
}

@end
