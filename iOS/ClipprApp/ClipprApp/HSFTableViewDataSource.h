//
//  HSFTableViewDataSource.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const kHSFTodayViewControllerMaxItems;

@class HSFClipboardItem;
@class HSFModelController;

@interface HSFTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak, readonly) HSFModelController *modelController;
@property (nonatomic, copy, readonly) NSArray<HSFClipboardItem *> *items;

- (instancetype)initWithModelController:(HSFModelController *)controller;

@end
