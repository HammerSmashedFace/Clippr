//
//  SFRTFClipboardItem.h
//  Clippr
//
//  Created by Viktor Radulov on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"

@interface SFRTFClipboardItem : SFClipboardItem

@property (nonatomic, retain) NSAttributedString *attributedString;

@end
