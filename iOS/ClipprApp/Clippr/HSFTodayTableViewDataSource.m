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
#import "HSFCustomTableViewCell.h"

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count >= kHSFTodayViewControllerMaxItems ? kHSFTodayViewControllerMaxItems : self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HSFCustomTableViewCell *cell = (HSFCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kHSFCustomTableViewCellIdentifier];

	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}

	NSArray *items = self.items;
	if (items.count > 0)
	{
		HSFClipboardItem *clipboardItem = [items objectAtIndex:indexPath.row];
		cell.textLabel.text = clipboardItem.text;

		[cell.dateLabel removeFromSuperview];
	}

	return cell;
}

@end
