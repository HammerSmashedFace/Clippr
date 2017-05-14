//
//  SFAuthorImageTransformer.m
//  Clippr
//
//  Created by Viktor Radulov on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFAuthorImageTransformer.h"

#import <Cocoa/Cocoa.h>

@implementation SFAuthorImageTransformer

+ (Class)transformedValueClass
{
	return [NSImage class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (nullable id)transformedValue:(NSString *)value;
{
	NSImage *result = nil;
	if ([value isEqualToString:@"MAC"])
	{
		result = [NSImage imageNamed:@"MAC"];
	}
	else if ([value isEqualToString:@"android"])
	{
		result = [NSImage imageNamed:@"android"];
	}
	else if ([value isEqualToString:@"iOS"])
	{
		result = [NSImage imageNamed:@"iOS"];
	}
	return result;
}

@end
