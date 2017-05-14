//
//  HSFModelController.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFModelController.h"
#import "HSFDataController.h"
#import "HSFEventManager.h"
#import "HSFJSONManager.h"
#import "HSFClipboardItem.h"

NSString *kHSFTodayViewControllerContext = @"com.HammerSmashedFace.Clippr";

@interface HSFModelController ()

@property (nonatomic, strong, readwrite) HSFDataController *dataController;
@property (nonatomic, strong, readwrite) HSFEventManager *eventManager;
@property (nonatomic, strong, readwrite) HSFJSONManager *jsonManager;

@end

@implementation HSFModelController

- (instancetype)init
{
	self = [super init];

	if (self)
	{
		_dataController = [[HSFDataController alloc] init];
		_eventManager = [[HSFEventManager alloc] init];
		_jsonManager = [[HSFJSONManager alloc] init];

		[_eventManager configureSocket];

		_dataController.delegate = (id<HSFDataControllerDelegate>)_eventManager;
		_eventManager.delegate = (id<HSFEventManagerDelegate>)_jsonManager;
		_jsonManager.delegate = (id<HSFJSONManagerDelegate>)_dataController;

		[_dataController addObserver:self forKeyPath:@"items" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&kHSFTodayViewControllerContext];
	}

	return self;
}

- (void)dealloc
{
	[_dataController removeObserver:self forKeyPath:@"items"];
}

- (NSArray<HSFClipboardItem *> *)items
{
	return self.dataController.items;
}

- (void)addItem:(HSFClipboardItem *)item
{
	[self.dataController addItem:item];
}

- (void)fetchHistory
{
	[self.dataController fetchItems];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (context == &kHSFTodayViewControllerContext && object == self.dataController && [keyPath isEqualToString:@"items"])
	{
		[self.delegate modelControllerDidUpdateHistory:self];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
