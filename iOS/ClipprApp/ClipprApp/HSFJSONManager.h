//
//  HSFJSONManager.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSFJSONManager;

@protocol HSFJSONManagerDelegate <NSObject>

- (void)jsonManager:(HSFJSONManager *)manager didReceiveItem:(NSDictionary *)data;
- (void)jsonManager:(HSFJSONManager *)manager didUpdateData:(NSArray *)data;

@end

@interface HSFJSONManager : NSObject

@property (nonatomic, weak, readwrite) id<HSFJSONManagerDelegate> delegate;

@end
