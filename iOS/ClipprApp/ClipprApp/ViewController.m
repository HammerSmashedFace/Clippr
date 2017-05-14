//
//  ViewController.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "ViewController.h"
#import "HSFModelController.h"
#import "HSFClipboardItem.h"
#import "HSFTableViewDelegate.h"
#import "HSFTableViewDataSource.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, HSFModelControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic, strong, readwrite) HSFModelController *modelController;
@property (nonatomic, strong, readwrite) HSFTableViewDataSource *dataSource;
@property (nonatomic, strong, readwrite) HSFTableViewDelegate *tableViewDelegate;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.modelController = [[HSFModelController alloc] init];
	self.modelController.delegate = self;

	self.dataSource = [[HSFTableViewDataSource alloc] initWithModelController:self.modelController];
	self.historyTableView.dataSource = self.dataSource;

	self.tableViewDelegate = [[HSFTableViewDelegate alloc] init];
	self.historyTableView.delegate = self.tableViewDelegate;
}	

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - UITableView methods

- (IBAction)longTapRecognizer:(UILongPressGestureRecognizer *)sender
{
	CGPoint location = [sender locationInView:self.historyTableView];
	NSIndexPath *indexPath = [self.historyTableView indexPathForRowAtPoint:location];
	NSString *selectedValue = self.dataSource.items[indexPath.item].text;
	NSDictionary *items = [NSDictionary dictionaryWithObject:selectedValue forKey:(NSString *)kUTTypeUTF8PlainText];
	[[UIPasteboard generalPasteboard] setItems:@[items]];
}

#pragma mark - Observing

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

#pragma mark - HSFModelControllerDelegate

- (void)modelControllerDidUpdateHistory:(HSFModelController *)controller
{
	[self.historyTableView reloadData];
}

@end
