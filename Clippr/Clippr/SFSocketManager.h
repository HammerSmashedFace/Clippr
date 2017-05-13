//
//  SFSocketManager.h
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "SFClipboardItem.h"

#import <Foundation/Foundation.h>
#import <SocketIO/Socket.IO-Client-Swift-umbrella.h>

@interface SFSocketManager : NSObject

- (void)connect;

- (void)copyItem:(SFClipboardItem * _Nonnull)item;

- (void)getHistoryWithCompletionBlock:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))completionBlock;
- (void)getMessageWithCompletionBlock:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))completionBlock;

@end
