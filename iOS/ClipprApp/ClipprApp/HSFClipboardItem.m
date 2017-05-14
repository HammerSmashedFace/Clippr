//
//  HSFClipboardItem.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFClipboardItem.h"

@interface HSFClipboardItem ()

@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, copy, readwrite) NSDate *date;

@end

@implementation HSFClipboardItem

- (instancetype)init
{
	NSLog(@"Shouldn't be called!");
	
	return [self initWithText:nil date:nil];
}

- (instancetype)initWithText:(NSString *)text
{
	return [self initWithText:text date:[NSDate date]];
}

- (instancetype)initWithText:(NSString *)text date:(NSDate *)date
{
	if (text != nil && date != nil)
	{
		self = [super init];

		if (self)
		{
			_text = text;
			_date = date;
		}
	}
	return self;
}

@end

@implementation HSFClipboardItem (HSFSerializing)

- (instancetype)initWithJSONRepresentation:(NSDictionary *)representation
{
	NSNumber *timestamp = representation[@"timestamp"];
	return [self initWithText:representation[@"text"] date:[NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000.0]];
}

- (NSDictionary *)jsonRepresentation
{
	return @{ @"text" : self.text, @"date" : @(self.date.timeIntervalSince1970), @"author" : @"iOS" };
}

@end
