//
//  SFImageClipboardItem.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"

@interface SFImageClipboardItem : SFClipboardItem

@property (nonatomic, retain) NSImage *image;

@end
