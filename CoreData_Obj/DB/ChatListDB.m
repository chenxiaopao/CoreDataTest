//
//  ChatListDB.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "ChatListDB.h"
#import "CoreDataManager.h"
#import "ChatList+CoreDataProperties.h"
#import "PredicateHelper.h"
#import "PredicateModel.h"

@interface ChatListDB ()

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *chatDate;
@property (nonatomic, copy) NSString *noReadNum;
@property (nonatomic, copy) NSString *isBusiness;

@end


@implementation ChatListDB

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.channel = @"channel";
        self.avatarUrl = @"band_url";
        self.company = @"company";
        self.nickname = @"nickname";
        self.email = @"email";
        self.tableName = @"ChatList";
        self.chatDate = @"chat_date";
        self.noReadNum = @"non_reading";
        self.isBusiness = @"is_business";
    }
    return self;
}

- (void)insertChatListWithDevice:(TBShareDevice *)device{
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:device.channelId rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate =  [PredicateHelper predicateWithModelArray:@[model]];
    BOOL isExist = [CoreDataManager.shared isExistWithTableName:self.tableName predicate:predicate];
    if (isExist){
        [self updateChatListWithDevice:device];
    }else{
        
        NSDictionary *dict = @{
                               self.channel : device.channelId,
                               self.avatarUrl : device.avatarUrl,
                               self.company : device.companyName,
                               self.chatDate : [NSDate date],
                               self.nickname : device.nickname,
                               self.noReadNum : @0,
                               self.email : device.mail,
                               self.isBusiness : @1
                               };
//        //正常传参模式
//        BOOL isSucceed = [CoreDataManager.shared insertWithTableName:self.tableName propertits:dict];
        
        //链式调用模式
        BOOL isSucceed = [CoreDataManager insert:^(CoreDataManager * _Nonnull manager) {
            manager.tableName(self.tableName).propertites(dict);
        }];
        if (isSucceed){
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
}

- (void)updateDateWithChannelId:(NSString *)channelId device:(nonnull TBShareDevice *)device{
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:device.channelId rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate =  [PredicateHelper predicateWithModelArray:@[model]];
    NSDictionary *dict = @{
                           self.channel : device.channelId,
                           self.avatarUrl : device.avatarUrl,
                           self.company : device.companyName,
                           self.chatDate : [NSDate date],
                           self.nickname : device.nickname,
                           self.noReadNum : @0,
                           self.email : device.mail,
                           self.isBusiness : @0
                           };
//    //正常传参模式
//    [CoreDataManager.shared modifyWithTableName:self.tableName predicate:predicate properties:dict];
    
    //链式调用模式
    [CoreDataManager modify:^(CoreDataManager * _Nonnull manager) {
        manager.tableName(self.tableName).predicate(predicate).propertites(dict);
    }];
}

- (void)updateChatListWithDevice:(TBShareDevice *)device{
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:device.channelId rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    
    NSPredicate *predicate =  [PredicateHelper predicateWithModelArray:@[model]];
    NSDictionary *dict = @{
                           self.chatDate : [NSDate date],
                           self.avatarUrl : device.avatarUrl,
                           self.company : device.companyName,
                           self.nickname : device.nickname,
                           self.email : device.mail,
                           self.isBusiness : @0
                           };
//    //正常传参模式
//    [CoreDataManager.shared modifyWithTableName:self.tableName predicate:predicate properties:dict];
    
    //链式调用模式
    [CoreDataManager modify:^(CoreDataManager * _Nonnull manager) {
        manager.tableName(self.tableName).predicate(predicate).propertites(dict);
    }];
}

- (NSArray<ChatListModel *> *)getChatListFromTable{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:self.chatDate ascending:NO];
    NSMutableArray *chatListModelArray = [NSMutableArray array];
    
//    //正常传参模式
//    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:sort fetchResultHandler:^(NSArray * _Nullable result) {
//        for (ChatList *chat in result) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            NSString *chatDate = [formatter stringFromDate:chat.chat_date];
//            ChatListModel *model = [ChatListModel modelWithAccountId:chat.channel nickName:chat.nickname companyName:chat.company avatarUrl:chat.band_url chatDate:chatDate mail:chat.email isBusiness:chat.is_business];
//            [chatListModelArray addObject:model];
//        }
//    }];

    //链式调用模式
    [CoreDataManager querySync:^(CoreDataManager * _Nonnull manager) {
        manager.tableName(self.tableName).sort(sort).fetchHandler(^(NSArray * _Nullable result) {
            for (ChatList *chat in result) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *chatDate = [formatter stringFromDate:chat.chat_date];
                ChatListModel *model = [ChatListModel modelWithAccountId:chat.channel nickName:chat.nickname companyName:chat.company avatarUrl:chat.band_url chatDate:chatDate mail:chat.email isBusiness:chat.is_business];
                [chatListModelArray addObject:model];
            }
        });
    }];
    return chatListModelArray;
}

- (void)deleteChatListWithChannelId:(NSString *)channelId{
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:channelId rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    
    NSPredicate *predicate =  [PredicateHelper predicateWithModelArray:@[model]];
    if ([CoreDataManager.shared isExistWithTableName:self.tableName predicate:predicate]){
//        //正常传参模式
//        [CoreDataManager.shared deleteWithTableName:self.tableName predicate:predicate];
        
        //链式调用模式
        [CoreDataManager deleteTable:^(CoreDataManager * _Nonnull manager) {
            manager.tableName(self.tableName).predicate(predicate);
        }];
    }else{
        NSLog(@"数据不存在");
    }
}


@end
