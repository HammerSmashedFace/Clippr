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

#import "HSFCustomTableViewCell.h"

#import <MobileCoreServices/MobileCoreServices.h>
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

	self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

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

- (UIPasteboard *)pasteboard
{
	return [UIPasteboard generalPasteboard];
}

- (NSArray<HSFClipboardItem *> *)items
{
	NSMutableArray *result = [NSMutableArray array];

	if (self.dataController.items.count != 0)
	{
		NSInteger itemsCount = self.dataController.items.count;
		NSInteger rangeLength = itemsCount > kHSFTodayViewControllerMaxItems ? kHSFTodayViewControllerMaxItems : itemsCount;
		NSInteger rangeLocation = itemsCount > kHSFTodayViewControllerMaxItems ? itemsCount - kHSFTodayViewControllerMaxItems : 0;
		NSRange indexesRange = NSMakeRange(rangeLocation, rangeLength);
		NSArray *rangedItems = [self.dataController.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexesRange]];

		NSSortDescriptor *sortDescripted = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
		[result addObjectsFromArray:[rangedItems sortedArrayUsingDescriptors:@[sortDescripted]]];
	}
	
	return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView methods

- (IBAction)longTapRecognizer:(UILongPressGestureRecognizer *)sender
{
	CGPoint location = [sender locationInView:self.view];
	NSIndexPath *indexPath = [self.itemsTableView indexPathForRowAtPoint:location];
	NSString *selectedValue = self.items[indexPath.item].text;
	NSDictionary *items = [NSDictionary dictionaryWithObject:selectedValue forKey:(NSString *)kUTTypeUTF8PlainText];
	[[UIPasteboard generalPasteboard] setItems:@[items]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count > kHSFTodayViewControllerMaxItems ? kHSFTodayViewControllerMaxItems : self.items.count;
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

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (context == &kHSFTodayViewControllerContext && object == self.dataController && [keyPath isEqualToString:@"items"])
	{
		[self.itemsTableView reloadData];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
