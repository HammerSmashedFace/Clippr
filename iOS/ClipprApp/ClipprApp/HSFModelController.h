//
//  HSFModelController.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSFClipboardItem;
@class HSFModelController;

@protocol HSFModelControllerDelegate <NSObject>

- (void)modelControllerDidUpdateHistory:(HSFModelController *)controller;

@end

@interface HSFModelController : NSObject

@property (nonatomic, copy, readonly) NSArray<HSFClipboardItem *> *items;
@property (nonatomic, weak, readwrite) id<HSFModelControllerDelegate> delegate;

- (void)addItem:(HSFClipboardItem *)item;
- (void)fetchHistory;

@end
