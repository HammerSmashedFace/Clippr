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
#import <Carbon/Carbon.h>

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
	self.lastChangeCount++;
	[self.pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[self.pasteboard setString:item.name forType:item.type];
	
	CGEventSourceRef sourceRef = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
	if (!sourceRef)
	{
		NSLog(@"No event source");
		return;
	}
	CGKeyCode veeCode = kVK_ANSI_V;
	CGEventRef eventDown = CGEventCreateKeyboardEvent(sourceRef, veeCode, true);
	CGEventSetFlags(eventDown, kCGEventFlagMaskCommand|0x000008);
	CGEventRef eventUp = CGEventCreateKeyboardEvent(sourceRef, veeCode, false);
	CGEventPost(kCGHIDEventTap, eventDown);
	CGEventPost(kCGHIDEventTap, eventUp);
	CFRelease(eventDown);
	CFRelease(eventUp);
	CFRelease(sourceRef);
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
