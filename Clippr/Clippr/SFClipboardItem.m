//
//  SFClipboardItem.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"

@interface SFClipboardItem()

@end

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

- (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation
{
	NSRunningApplication *runningApplication = [NSRunningApplication runningApplicationsWithBundleIdentifier:dictionaryRepresentation[@"bundleID"] ?: @""].firstObject;
	self = [self initWithName:dictionaryRepresentation[@"text"] source:runningApplication];
	if (self)
	{
		_creationDate = [[NSDate dateWithTimeIntervalSince1970:[dictionaryRepresentation[@"timestamp"] doubleValue] / 1000.0] retain];
		_type = [NSPasteboardTypeString copy];
	}
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	return @{
	  @"text" : self.name,
	  @"bundleID" : self.source.bundleIdentifier,
	  @"timestamp" : [NSString stringWithFormat:@"%f", [self.creationDate timeIntervalSince1970] * 1000.0],
	  @"type" : self.type};
}

- (NSData *)data
{
	return [self.name dataUsingEncoding:NSUTF8StringEncoding];
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

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

@end
