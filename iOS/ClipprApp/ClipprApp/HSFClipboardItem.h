//
//  HSFClipboardItem.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFClipboardItem : NSObject

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSDate *date;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text date:(NSDate *)date NS_DESIGNATED_INITIALIZER;

@end


@interface HSFClipboardItem (HSFSerializing)

- (NSDictionary *)jsonRepresentation;
- (instancetype)initWithJSONRepresentation:(NSDictionary *)representation;

@end
