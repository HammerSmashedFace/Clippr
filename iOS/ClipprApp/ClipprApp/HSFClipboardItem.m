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

}

- (NSDictionary *)jsonRepresentation
{

}

@end
