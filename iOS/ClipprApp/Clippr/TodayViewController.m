//
//  TodayViewController.m
//  Clippr
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "TodayViewController.h"
#import "HSFDataController.h"
#import "HSFEventManager.h"
#import "HSFJSONManager.h"
#import "HSFClipboardItem.h"

#import <NotificationCenter/NotificationCenter.h>

NSString *kHSFTodayViewControllerContext = @"com.HammerSmashedFace.Clippr";
NSInteger const kHSFTodayViewControllerMaxItems = 3;

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong, readwrite) HSFDataController *dataController;
@property (nonatomic, strong, readwrite) HSFEventManager *eventManager;
@property (nonatomic, strong, readwrite) HSFJSONManager *jsonManager;

@property (nonatomic, strong, readonly) NSArray<HSFClipboardItem *> *items;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.dataController = [[HSFDataController alloc] init];
	self.eventManager = [[HSFEventManager alloc] init];
	self.jsonManager = [[HSFJSONManager alloc] init];

	[self.eventManager configureSocket];

	self.dataController.delegate = (id<HSFDataControllerDelegate>)self.eventManager;
	self.eventManager.delegate = (id<HSFEventManagerDelegate>)self.jsonManager;
	self.jsonManager.delegate = (id<HSFJSONManagerDelegate>)self.dataController;

	[self.dataController addObserver:self forKeyPath:@"items" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&kHSFTodayViewControllerContext];
}

- (void)dealloc
{
	[_dataController removeObserver:self forKeyPath:@"items"];
}

- (NSArray<HSFClipboardItem *> *)items
{
	NSArray *result = nil;

	if (self.dataController.items.count != 0)
	{
		NSInteger itemsCount = self.dataController.items.count;
		NSInteger rangeLength = itemsCount > kHSFTodayViewControllerMaxItems ? kHSFTodayViewControllerMaxItems : itemsCount;
		NSInteger rangeLocation = itemsCount > kHSFTodayViewControllerMaxItems ? itemsCount - kHSFTodayViewControllerMaxItems : 0;
		NSRange indexesRange = NSMakeRange(rangeLocation, rangeLength);
		result = [self.dataController.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexesRange]];
	}
	
	return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return kHSFTodayViewControllerMaxItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"TextIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}

	HSFClipboardItem *clipboardItem = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = clipboardItem.text;

	return cell;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (context == &kHSFTodayViewControllerContext && [keyPath isEqualToString:@"items"])
	{
		[self.itemsTableView reloadData];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
