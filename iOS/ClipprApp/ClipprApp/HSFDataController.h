//
//  HSFDataController.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFClipboardItem.h"

#import <Foundation/Foundation.h>

@class HSFDataController;

@protocol HSFDataControllerDelegate <NSObject>

- (void)dataController:(HSFDataController *)controller didReceiveItem:(HSFClipboardItem *)item;

@end

@interface HSFDataController : NSObject

@property (nonatomic, copy, readonly) NSArray<HSFClipboardItem *> *items;
@property (nonatomic, weak, readwrite) id<HSFDataControllerDelegate> delegate;

- (void)addItem:(HSFClipboardItem *)item;

@end
