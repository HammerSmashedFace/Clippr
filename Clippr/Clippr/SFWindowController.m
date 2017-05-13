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

@interface SFWindowController () <NSWindowDelegate>
@property (assign) IBOutlet NSTableView *tableView;

@end

@implementation SFWindowController

- (void)windowDidLoad
{
	self.window.level = kCGCursorWindowLevel;
}

- (void)showWindow:(id)sender
{
	[super showWindow:sender];
	
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:nil];
}

- (IBAction)tableAction:(id)sender
{
	[self.window orderOut:nil];
	[self.manager pasteItem:self.manager.items[[self.tableView selectedRow]]];
}

- (void)flagsChanged:(NSEvent *)event
{
	NSLog(@"flags");
}

- (void)moveDown:(id)sender
{
	if (self.tableView.selectedRow == self.manager.items.count - 1)
	{
		[self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	}
	else
	{
		[self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.tableView.selectedRow + 1] byExtendingSelection:NO];
	}
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self.manager pasteItem:self.manager.items[[self.tableView selectedRow]]];
}

@end
