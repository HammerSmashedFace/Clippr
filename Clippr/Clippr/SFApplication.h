//
//  SFApplication.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFApplication : NSObject

@property (nonatomic, copy) NSString *localizedName;
@property (nonatomic, copy) NSImage *icon;

- (NSDictionary *)dictionaryRepresentation;

@end
