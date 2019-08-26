//
//  ChatListModel.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "ChatListModel.h"

@implementation ChatListModel

+ (instancetype)modelWithAccountId:(NSString *)id nickName:(NSString *)nickName companyName:(NSString *)companyName avatarUrl:(NSString *)avatarUrl chatDate:(NSString *)chatDate mail:(NSString *)mail isBusiness:(BOOL)isBusiness{
    ChatListModel *model = [[ChatListModel alloc]init];
    model.accountId = id;
    model.nickname = nickName;
    model.companyName = companyName;
    model.avatarUrl = avatarUrl;
    model.chatDate = chatDate;
    model.mail = mail;
    model.isBusiness = isBusiness;
    return model;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"id:%@   ickname:%@   company:%@    avatarUrl:%@     chatDate:%@    mail:%@   isBusiness%@", self.accountId,self.nickname,self.companyName,self.avatarUrl,self.chatDate,self.mail,self.isBusiness?@"yes":@"no"];
}

@end
