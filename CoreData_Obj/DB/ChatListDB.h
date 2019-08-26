//
//  ChatListDB.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "ChatListModel.h"
#import "TBShareDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatListDB : NSObject

+ (instancetype)shared;

- (NSArray<ChatListModel *> *)getChatListFromTable;

- (void)insertChatListWithDevice:(TBShareDevice *)device;

- (void)updateDateWithChannelId:(NSString *)channelId device:(TBShareDevice *)device;;

- (void)deleteChatListWithChannelId:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
