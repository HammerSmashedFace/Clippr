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

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong, readwrite) HSFDataController *dataController;
@property (nonatomic, strong, readwrite) HSFEventManager *eventManager;
@property (nonatomic, strong, readwrite) HSFJSONManager *jsonManager;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
	self.dataController = [[HSFDataController alloc] init];
	self.eventManager = [[HSFEventManager alloc] init];
	self.jsonManager = [[HSFJSONManager alloc] init];

	[self.eventManager configureSocket];

	self.dataController.delegate = (id<HSFDataControllerDelegate>)self.eventManager;
	self.eventManager.delegate = (id<HSFEventManagerDelegate>)self.jsonManager;
	self.jsonManager.delegate = (id<HSFJSONManagerDelegate>)self.dataController;

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[UITableViewCell alloc] init];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
	NSLog(@"log");
    completionHandler(NCUpdateResultNewData);
}

@end
