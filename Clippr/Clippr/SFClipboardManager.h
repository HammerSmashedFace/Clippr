//
//  SFClipboardManager.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFClipboardItem.h"

@interface SFClipboardManager : NSObject

@property (nonatomic, retain, readonly) NSArray <__kindof SFClipboardItem *> *items;
- (void)pasteItem:(__kindof SFClipboardItem *)item;

@end
