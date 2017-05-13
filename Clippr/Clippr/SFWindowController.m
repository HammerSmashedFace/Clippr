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
	self.window.level = kCGMainMenuWindowLevel;
	self.window.backgroundColor = [NSColor clearColor];
}

- (IBAction)tableAction:(id)sender
{
	[self.window orderOut:nil];
	[self.manager pasteItem:self.manager.items[[self.tableView selectedRow]]];
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

- (void)windowWillClose:(NSNotification *)notification
{
	[self.manager pasteItem:self.manager.items[[self.tableView selectedRow]]];
}

@end
