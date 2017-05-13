//
//  SFApplication.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFApplication.h"

@implementation SFApplication

- (NSDictionary *)dictionaryRepresentation
{
	return @{@"appName" : self.localizedName,
			 @"appIcon" : self.icon};
}

@end
