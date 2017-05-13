//
//  KeyboardViewController.m
//  ClipprKeyboard
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@property (nonatomic, retain, readwrite) NSMutableArray<NSString *> *data;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.data = [NSMutableArray arrayWithObjects:@"1",  @"2", @"3", @"4", @"5", @"6", @"7", nil];
}

- (NSString *)nibName
{
	return @"KeyboardView";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"clippboard";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
 
	cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = indexPath.row;
	if (row < self.data.count)
	{
		[self.textDocumentProxy insertText:self.data[row]];
	}
	[self advanceToNextInputMode];
}

@end
