//
//  SFClipboardItem.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"

@implementation SFClipboardItem

- (instancetype)initWithName:(NSString *)name source:(NSRunningApplication *)source
{
	self = [super init];
	if (self)
	{
		_name = [name copy];
		_source = [source retain];
		_creationDate = [[NSDate date] retain];
	}
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	return @{
	  @"name" : self.name,
	  @"source" : self.source.localizedName,
	  @"type" : self.type,
	  @"date" : self.creationDate};
}

- (id)copyWithZone:(NSZone *)zone
{
	SFClipboardItem *result = [[SFClipboardItem alloc] init];
	result->_name = [self.name copy];
	result->_source = [self.source retain];
	result->_type = [self.type copy];
	return result;
}

- (NSString *)description
{
	return self.name;
}

@end
