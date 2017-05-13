//
//  HSFEventManager.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSFEventManager;

@protocol HSFEventManagerDelegate <NSObject>

- (void)eventManager:(HSFEventManager *)manager didReceiveData:(NSDictionary *)data;

@end

@interface HSFEventManager : NSObject

@property (nonatomic, weak, readwrite) id<HSFEventManagerDelegate> delegate;

- (void)configureSocket;

@end
