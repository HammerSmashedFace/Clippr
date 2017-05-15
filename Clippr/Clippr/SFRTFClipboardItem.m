//
//  SFRTFClipboardItem.m
//  Clippr
//
//  Created by Viktor Radulov on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFRTFClipboardItem.h"

@implementation SFRTFClipboardItem

- (NSData *)data
{
	return [self.attributedString RTFFromRange:NSMakeRange(0, self.attributedString.length) documentAttributes:@{}] ?: [super data];
}

@end
