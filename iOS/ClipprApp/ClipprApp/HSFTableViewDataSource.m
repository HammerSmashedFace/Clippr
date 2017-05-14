//
//  HSFTableViewDataSource.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFTableViewDataSource.h"
#import "HSFModelController.h"
#import "HSFClipboardItem.h"
#import "HSFCustomTableViewCell.h"

NSInteger const kHSFTodayViewControllerMaxItems = 3;

@interface HSFTableViewDataSource ()

@property (nonatomic, weak, readwrite) HSFModelController *modelController;

@end

@implementation HSFTableViewDataSource

- (instancetype)initWithModelController:(HSFModelController *)controller
{
	self = [super init];

	if (self)
	{
		_modelController = controller;
	}

	return self;
}

- (NSArray *)items
{
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
	return [self.modelController.items sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
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
	}

	return cell;
}

@end
