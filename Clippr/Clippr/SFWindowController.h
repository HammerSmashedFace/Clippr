//
//  SFWindowController.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SFClipboardManager;

@interface SFWindowController : NSWindowController

@property (nonatomic, retain) SFClipboardManager *manager;

@end
