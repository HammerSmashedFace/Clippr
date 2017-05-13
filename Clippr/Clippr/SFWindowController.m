//
//  SFWindowController.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFWindowController.h"

@interface SFWindowController () <NSWindowDelegate>

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

- (void)windowDidBecomeKey:(NSNotification *)notification
{
//	[self close];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	[self close];
}

@end
