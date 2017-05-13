//
//  main.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		AppDelegate *delegate = [[AppDelegate alloc] init];
		[NSApplication sharedApplication].delegate = delegate;
		[NSApp run];
		[delegate release];
	}
}
