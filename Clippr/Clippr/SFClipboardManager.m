//
//  SFClipboardManager.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardManager.h"
#import "SFClipboardItem.h"

#import <Cocoa/Cocoa.h>

@interface SFClipboardManager()

@property (nonatomic, retain) NSPasteboard *pasteboard;
@property (nonatomic, retain) NSMutableArray <__kindof SFClipboardItem *> *items;
@property (nonatomic) NSUInteger lastChangeCount;

@end

@implementation SFClipboardManager

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_lastChangeCount = self.pasteboard.changeCount;
		[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer)
		{
			if (self.pasteboard.changeCount > self.lastChangeCount)
			{
				[self willChangeValueForKey:@"items"];
				
				NSRunningApplication *currentRunningApp = nil;
				for (NSRunningApplication *runningApp in [[NSWorkspace sharedWorkspace] runningApplications])
				{
					if ([runningApp isActive])
					{
						currentRunningApp = runningApp;
						break;
					}
				}
				SFClipboardItem *item = [[SFClipboardItem alloc] initWithName:[self.pasteboard stringForType:NSPasteboardTypeString] source:currentRunningApp];
				item.type = NSPasteboardTypeString;
				[((NSMutableArray *)[self items]) addObject:item];
				[item release];
				[self didChangeValueForKey:@"items"];
			}
			self.lastChangeCount = self.pasteboard.changeCount;
		}];
	}
	return self;
}

- (void)pasteItem:(__kindof SFClipboardItem *)item
{
	[self.pasteboard writeObjects:@[item]];
}

- (NSPasteboard *)pasteboard
{
	return [NSPasteboard generalPasteboard];
}

- (NSMutableArray<SFClipboardItem *> *)items
{
	if (_items == nil)
	{
		_items = [[NSMutableArray alloc] init];
	}
	return _items;
}

@end
