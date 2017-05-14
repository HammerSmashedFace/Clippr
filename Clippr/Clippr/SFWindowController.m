//
//  SFWindowController.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFWindowController.h"
#import "SFClipboardManager.h"
#import "SFClipboardItem.h"
#import <QuickLook/QuickLook.h>

#import <Carbon/Carbon.h>

@interface SFWindowController () <NSWindowDelegate>

@property (assign) IBOutlet NSTableView *tableView;

@property (nonatomic, copy, readonly) NSPredicate *filterPredicate;
@property (nonatomic, copy) NSString *searchPhrase;

@end

@implementation SFWindowController

- (NSPredicate *)filterPredicate
{
	return self.searchPhrase ? [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings)
	{
		return [((SFClipboardItem *)evaluatedObject).name containsString:self.searchPhrase];
	}] : nil;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingFilterPredicate
{
	return [NSSet setWithObject:@"searchPhrase"];
}

- (void)windowDidLoad
{
	self.window.level = kCGMainMenuWindowLevel;
	self.window.backgroundColor = [NSColor clearColor];
}

- (IBAction)tableAction:(id)sender
{
	SFClipboardItem *selectedItem = self.manager.items[[self.tableView selectedRow]];
	[NSApp hide:self];
	[self.manager pasteItem:selectedItem];
}

- (IBAction)closeWindow:(id)sender
{
	self.window.delegate = nil;
	[self close];
	self.window.delegate = self;
}

- (void)moveDown:(id)sender
{
	NSUInteger rowToSelect = 0;
	NSTableView *tableView = self.tableView;
	if (tableView.selectedRow != self.manager.items.count - 1)
	{
		rowToSelect = tableView.selectedRow + 1;
	}
	[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:rowToSelect] byExtendingSelection:NO];
	[tableView scrollRowToVisible:rowToSelect];
}

- (void)showWindow:(id)sender
{
	[super showWindow:sender];
	
	if (sender == nil)
	{
		CGEventRef ourEvent = CGEventCreate(NULL);
		CGPoint mouseLocation = CGEventGetLocation(ourEvent);
		mouseLocation.y = [NSScreen mainScreen].frame.size.height - mouseLocation.y + 10.0;
		mouseLocation.x -= 10.0;
		CFRelease(ourEvent);
		
		[self.window setFrameOrigin:mouseLocation];
	}
	[self.tableView reloadData];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self.manager pasteItem:self.manager.items[[self.tableView selectedRow]]];
}

@end
