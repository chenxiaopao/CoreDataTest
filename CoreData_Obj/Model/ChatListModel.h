//
//  ChatListModel.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListModel : NSObject

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *chatDate;
@property (nonatomic, copy) NSString *mail;
@property (nonatomic, assign) BOOL isBusiness;

+ (instancetype)modelWithAccountId:(NSString *)id nickName:(NSString *)nickName companyName:(NSString *)companyName avatarUrl:(NSString *)avatarUrl chatDate:(NSString *)chatDate mail:(NSString *)mail isBusiness:(BOOL)isBusiness;

@end

NS_ASSUME_NONNULL_END
