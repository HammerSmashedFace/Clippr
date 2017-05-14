//
//  TodayViewController.m
//  Clippr
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "TodayViewController.h"
#import "HSFTodayTableViewDataSource.h"
#import "HSFTableViewDelegate.h"
#import "HSFModelController.h"
#import "HSFClipboardItem.h"

#import "HSFCustomTableViewCell.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource, HSFModelControllerDelegate>

@property (nonatomic, weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong, readwrite) HSFModelController *modelController;
@property (nonatomic, strong, readwrite) HSFTableViewDataSource *dataSource;
@property (nonatomic, strong, readwrite) HSFTableViewDelegate *tableViewDelegate;

@property (nonatomic, strong, readonly) NSArray<HSFClipboardItem *> *items;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

	self.modelController = [[HSFModelController alloc] init];
	self.modelController.delegate = self;

	self.dataSource = [[HSFTableViewDataSource alloc] initWithModelController:self.modelController];
	self.itemsTableView.dataSource = self.dataSource;

	self.tableViewDelegate = [[HSFTableViewDelegate alloc] init];
	self.itemsTableView.delegate = self.tableViewDelegate;
}

- (UIPasteboard *)pasteboard
{
	return [UIPasteboard generalPasteboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)longTapRecognizer:(UILongPressGestureRecognizer *)sender
{
	CGPoint location = [sender locationInView:self.view];
	NSIndexPath *indexPath = [self.itemsTableView indexPathForRowAtPoint:location];
	NSString *selectedValue = self.items[indexPath.item].text;
	NSDictionary *items = [NSDictionary dictionaryWithObject:selectedValue forKey:(NSString *)kUTTypeUTF8PlainText];
	[[UIPasteboard generalPasteboard] setItems:@[items]];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
	[self.itemsTableView reloadData];

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
	if (activeDisplayMode == NCWidgetDisplayModeExpanded)
	{
		self.preferredContentSize = CGSizeMake(0.0, 245.0);
	}
	else if (activeDisplayMode == NCWidgetDisplayModeCompact)
	{
		self.preferredContentSize = CGSizeMake(0.0, 82.0);
	}
}

#pragma mark - HSFModelControllerDelegate

- (void)modelControllerDidUpdateHistory:(HSFModelController *)controller
{
	[self.itemsTableView reloadData];
}

@end
