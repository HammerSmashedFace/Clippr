//
//  SFClipboardItem.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFApplication;

@interface SFClipboardItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) SFApplication *source;

- (NSDictionary *)dictionaryRepresentation;

@end
