//
//  SFClipboardItem.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"
#import "SFApplication.h"

@implementation SFClipboardItem

- (instancetype)initWithName:(NSString *)name source:(NSRunningApplication *)source
{
	self = [super init];
	if (self)
	{
		_name = [name copy];
		_source = [source retain];
	}
	return self;
}

- (NSArray<NSString *> *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
	return @[self.type];
}

- (NSDictionary *)dictionaryRepresentation
{
	return @{
			 @"name" : self.name,
			 @"source" : self.source.localizedName};
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[SFClipboardItem alloc] initWithName:self.name source:self.source];
}

- (NSString *)description
{
	return self.name;
}

@end
