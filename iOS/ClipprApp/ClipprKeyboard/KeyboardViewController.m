//
//  KeyboardViewController.m
//  ClipprKeyboard
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "KeyboardViewController.h"
#import "HSFDataController.h"
#import "HSFEventManager.h"
#import "HSFJSONManager.h"

static NSString *kHSFKeyboardViewControllerContext = @"com.HammerSmashedFace.ClipprKeyboard";
static NSInteger const kHSFKeyboardViewControllerMaxItems = 5;

@interface KeyboardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *clippboardTableView;

@property (weak, nonatomic) IBOutlet UIView *row1;
@property (weak, nonatomic) IBOutlet UIView *row2;
@property (weak, nonatomic) IBOutlet UIView *row3;
@property (weak, nonatomic) IBOutlet UIView *row4;

@property (weak, nonatomic) IBOutlet UIView *charSet1;
@property (weak, nonatomic) IBOutlet UIView *charSet2;

@property (nonatomic, strong, readonly) NSArray<HSFClipboardItem *> *items;
@property (nonatomic, strong) HSFDataController *dataController;
@property (nonatomic, strong, readwrite) HSFEventManager *eventManager;
@property (nonatomic, strong, readwrite) HSFJSONManager *jsonManager;

@property (assign, nonatomic) BOOL capsLockOn;

@end

@implementation KeyboardViewController

- (HSFDataController *)dataController
{
	if (_dataController == nil)
	{
		_dataController = [[HSFDataController alloc] init];
	}
	return _dataController;
}

- (NSArray<HSFClipboardItem *> *)items
{
	NSArray *result = nil;
	
	if (self.dataController.items.count != 0)
	{
		NSInteger itemsCount = self.dataController.items.count;
		NSInteger rangeLength = itemsCount > kHSFKeyboardViewControllerMaxItems ? kHSFKeyboardViewControllerMaxItems : itemsCount;
		NSInteger rangeLocation = itemsCount > kHSFKeyboardViewControllerMaxItems ? itemsCount - kHSFKeyboardViewControllerMaxItems : 0;
		NSRange indexesRange = NSMakeRange(rangeLocation, rangeLength);
		NSArray *rangedItems = [self.dataController.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexesRange]];
		
		NSSortDescriptor *sortDescripted = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
		result = [rangedItems sortedArrayUsingDescriptors:@[sortDescripted]];
	}
	
	return result;
}


- (void)dealloc
{
	[_dataController removeObserver:self forKeyPath:@"items"];
}

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
	
	[self.dataController addObserver:self forKeyPath:@"items" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:&kHSFKeyboardViewControllerContext];
	
	self.capsLockOn = true;
	self.charSet1.hidden = false;
	self.charSet2.hidden = true;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (context == &kHSFKeyboardViewControllerContext && [keyPath isEqualToString:@"items"])
	{
		[self.clippboardTableView reloadData];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (NSString *)nibName
{
	return @"KeyboardView";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return kHSFKeyboardViewControllerMaxItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"clippboard";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
	}
	NSUInteger row = indexPath.row;
	if (row < self.dataController.items.count)
	{
		cell.textLabel.text = self.items[row].text;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = indexPath.row;
	if ( self.dataController.items != nil && row < self.dataController.items.count)
	{
		[self.textDocumentProxy insertText:self.items[row].text];
	}
}

- (IBAction)nextKeyboardPressed:(id)sender
{
	[self advanceToNextInputMode];
}

- (IBAction)capsLockPressed:(id)sender
{
	self.capsLockOn = !self.capsLockOn;
	
	[self changeCaps:self.row1];
	[self changeCaps:self.row2];
	[self changeCaps:self.row3];
	[self changeCaps:self.row4];
}

- (void)changeCaps:(UIView *)containerView
{
	for (UIView *view in containerView.subviews)
	{
		for (UIView *buttonView in view.subviews)
		{
			UIButton *button = (UIButton *)buttonView;
			NSString *buttonTitle = button.titleLabel.text;
			
			if (self.capsLockOn)
			{
				NSString *text = buttonTitle.uppercaseString;
				[button setTitle:text forState:UIControlStateNormal];
			}
			else
			{
				NSString *text = buttonTitle.lowercaseString;
				[button setTitle:text forState:UIControlStateNormal];
			}
		}
	}
}

- (IBAction)keyPressed:(UIButton *)button
{
	NSString *string = button.titleLabel.text;
	[self.textDocumentProxy insertText:string];
	
	[UIView animateWithDuration:0.2 animations:^{
		button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
	} completion:^(BOOL result){
		button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
	}];
}

- (IBAction)backSpacePressed:(UIButton *)button
{
	[self.textDocumentProxy deleteBackward];
}

- (IBAction)spacePressed:(UIButton *)button
{
	[self.textDocumentProxy insertText:@" "];
}

- (IBAction)returnPressed:(UIButton *)button
{
	[self.textDocumentProxy insertText:@"\n"];
}

- (IBAction)charSetPressed:(UIButton *)button
{
	if ([button.titleLabel.text isEqualToString:@"1/2"]) {
		self.charSet1.hidden = true;
		self.charSet2.hidden = false;
		[button setTitle:@"2/2" forState:UIControlStateNormal];
	}
	else if ([button.titleLabel.text isEqualToString:@"2/2"])
	{
		self.charSet1.hidden = false;
		self.charSet2.hidden = true;
		[button setTitle:@"1/2" forState:UIControlStateNormal];
	}
}

@end
