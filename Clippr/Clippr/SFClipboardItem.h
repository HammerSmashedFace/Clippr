//
//  SFClipboardItem.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SFClipboardItem : NSObject <NSCopying, NSPasteboardWriting>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSRunningApplication *source;

- (instancetype)initWithName:(NSString *)name source:(NSRunningApplication *)source;
- (NSDictionary *)dictionaryRepresentation;

@end
