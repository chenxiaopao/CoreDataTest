//
//  CoreData_ObjTests.m
//  CoreData_ObjTests
//
//  Created by TB-mac-120 on 2019/8/19.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ChatListDB.h"
#import "CoreDataManager.h"
#import "ChatList+CoreDataProperties.h"
#import "PredicateHelper.h"
#import "PredicateModel.h"

@interface CoreData_ObjTests : XCTestCase

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *chatDate;
@property (nonatomic, copy) NSString *noReadNum;
@property (nonatomic, copy) NSString *isBusiness;
@property (nonatomic, assign) NSInteger count;

@end

@implementation CoreData_ObjTests

- (void)setUp {
    self.channel = @"channel";
    self.avatarUrl = @"band_url";
    self.company = @"company";
    self.nickname = @"nickname";
    self.email = @"email";
    self.tableName = @"ChatList";
    self.chatDate = @"chat_date";
    self.noReadNum = @"non_reading";
    self.isBusiness = @"is_business";
    self.count = 10;
}

- (void)tearDown {
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - 添加假数据

- (void)setTestData{
    for (int i=0; i<self.count; i++) {
        NSDictionary *dict = @{
                               self.channel : [NSString stringWithFormat:@"channel%d",i],
                               self.avatarUrl : [NSString stringWithFormat:@"url%d",i],
                               self.company : [NSString stringWithFormat:@"companyName%d",i],
                               self.chatDate : [NSDate date],
                               self.nickname : @"nickname",
                               self.noReadNum : @0,
                               self.email : @"mail",
                               self.isBusiness : i%2 == 0 ? @1 : @0,
                               };
        [CoreDataManager.shared insertWithTableName:self.tableName propertits:dict];
    }
}

#pragma mark - 添加数据

- (void)testInsertToTable{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    
    NSDictionary *dict = @{
                           self.channel : @"channel",
                           self.avatarUrl : @"url",
                           self.company : @"companyName",
                           self.chatDate : [NSDate date],
                           self.nickname : @"nickname",
                           self.noReadNum : @0,
                           self.email : @"mail",
                           self.isBusiness : @1
                           };
    [CoreDataManager.shared insertWithTableName:self.tableName propertits:dict];
    BOOL isExist = [CoreDataManager.shared isExistWithTableName:self.tableName predicate:predicate];
    XCTAssertTrue(isExist == true,@"添加成功");

}


#pragma mark - 删除数据

- (void)testDeleteAllFromTable{
    [self setTestData];
    BOOL flag = [CoreDataManager.shared deleteWithTableName:self.tableName];
    XCTAssertTrue(flag);
    [CoreDataManager.shared querySyncWithTableName:self.tableName fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(0, result.count);
    }];
}

- (void)testDeleteFormTable{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    [self setTestData];
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel0" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    BOOL flag = [CoreDataManager.shared deleteWithTableName:self.tableName predicate:predicate];
    XCTAssertTrue(flag);
    
    [CoreDataManager.shared querySyncWithTableName:self.tableName fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(self.count-1, result.count);
    }];
}


#pragma mark - 修改数据

- (void)testModifyChatList{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    [self setTestData];
    sleep(1);
    
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel0" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    __block NSString *beforeString;
    __block NSString *afterString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDictionary *dict = @{
                           self.chatDate : [NSDate date],
                           };
    
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        ChatList *chat = result.firstObject;
        beforeString = [formatter stringFromDate:chat.chat_date];
    }];
    
    BOOL isSucceed = [CoreDataManager.shared modifyWithTableName:self.tableName predicate:predicate properties:dict];
    XCTAssertTrue(isSucceed);
    
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        ChatList *chat = result.firstObject;
        afterString = [formatter stringFromDate:chat.chat_date];
    }];
    XCTAssertNotEqual(beforeString, afterString);
}


#pragma mark - 查询数据

- (void)testAsyncOrSyncGetChatListFromTable{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    [self setTestData];
    
    [CoreDataManager.shared querySyncWithTableName:self.tableName fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    [CoreDataManager.shared queryAsyncWithTableName:self.tableName fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel0" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(1, result.count);
    }];
    
    [CoreDataManager.shared queryAsyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(1, result.count);
    }];
}

//根据条件查询 PreConditionType  JoinConditionType
- (void)testGetChatListWithConditionType{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    [self setTestData];
    
    //self.isBusiness 非 等于1
    PredicateModel *model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
        
    //self.isBusiness等于1且大于0
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    PredicateModel *model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1或大于0
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 且 非大于0
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 0);
    }];
    
    
    //self.isBusiness等于1 且 在{0，1}范围
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@0,@1] rule:RuleTypeBetween preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 或 在{0，1}范围
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@0,@1] rule:RuleTypeBetween preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //self.isBusiness等于1 且 self.channel以“chan”开始
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeBeginsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 或 self.channel以“chan”开始
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeBeginsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //self.isBusiness等于1 且 self.channel包含“chan”字符串
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeContains preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 或 self.channel包含“chan”字符串
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeContains preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //self.isBusiness等于1 且 self.channel以“1“结束
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"1" rule:RuleTypeEndsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 0);
    }];
    
    //self.isBusiness等于1 或 self.channel以“1”结束
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"1" rule:RuleTypeEndsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 6);
    }];
    
    //self.isBusiness等于1 且 self.channel like匹配 ”*c*“
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"*c*" rule:RuleTypeLike preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 或 self.channel like匹配 ”*c*“
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"*c*" rule:RuleTypeLike preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //self.isBusiness等于1 且 self.channel matches 匹配 @"^[a-zA-Z][a-zA-Z0-9_]*$"
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"^[a-zA-Z][a-zA-Z0-9_]*$" rule:RuleTypeMatches preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 或 self.channel matches 匹配 @"^[a-zA-Z][a-zA-Z0-9_]*$"
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.channel value:@"^[a-zA-Z][a-zA-Z0-9_]*$" rule:RuleTypeMatches preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    
    //self.isBusiness等于1 且在 {1,2,3,4,5}之间
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1  或 在 {1,2,3,4,5}之间
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //self.isBusiness等于1 且 非在 {1,2,3,4,5}之间
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 0);
    }];
    
    //self.isBusiness等于1 或 非在 {1,2,3,4,5}之间
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    

    //self.isBusiness 等于1 或 大于0 且 非在{1,2,3,4,5}之间
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    
    PredicateModel *model2 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeAnd];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1,model2]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //self.isBusiness 等于1 或 大于0 或 在{1,2,3,4,5}之间 或 非以“chan”开头
    model = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    model2 = [PredicateModel modelWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeOr];
    PredicateModel *model3 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeBeginsWith preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1,model2,model3]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    // 根据提供默认前置条件类型的构造函数
    //self.isBusiness 等于1 或 大于0 或 在{1,2,3,4,5}之间 或 非以“chan”开头
    model = [PredicateModel modelPreConditionNoneWithKey:self.isBusiness value:@1 rule:RuleTypeEqual  joinCondition:JoinConditionTypeNone];
    model1 = [PredicateModel modelWithKey:self.isBusiness value:@0 rule:RuleTypeGreatThan preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    model2 = [PredicateModel modelPreConditionNoneWithKey:self.isBusiness value:@[@1,@2,@3,@4,@5] rule:RuleTypeIn  joinCondition:JoinConditionTypeOr];
    model3 = [PredicateModel modelWithKey:self.channel value:@"chan" rule:RuleTypeBeginsWith preCondition:PreConditionTypeNot joinCondition:JoinConditionTypeOr];
    predicate = [PredicateHelper predicateWithModelArray:@[model,model1,model2,model3]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
}

//根据规则查询 RuleType =、 >、 <、 >=、 <=、 !=、  matches、 likes、 in、 between、  beginswith、 endswith
- (void)testGetChatListWithRuleType{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    [self setTestData];
    //等于
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel0" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:predicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 1);
    }];
    
    //大于等于
    PredicateModel *gtModel = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeGreatThanOrEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *gtPredicate = [PredicateHelper predicateWithModelArray:@[gtModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:gtPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //小于等于
    PredicateModel *ltModel = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeLessThanOrEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *ltPredicate = [PredicateHelper predicateWithModelArray:@[ltModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:ltPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //大于
    PredicateModel *gModel = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeGreatThan preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *gPredicate = [PredicateHelper predicateWithModelArray:@[gModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:gPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 0);
    }];
    
    //小于
    PredicateModel *lModel = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeLessThan preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *lPredicate = [PredicateHelper predicateWithModelArray:@[lModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:lPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
 
    //不等于
    PredicateModel *unEqualModel = [PredicateModel modelWithKey:self.isBusiness value:@1 rule:RuleTypeUnEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *unEqualPredicate = [PredicateHelper predicateWithModelArray:@[unEqualModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:unEqualPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
    
    //在某个范围之间
    PredicateModel *betweenModel = [PredicateModel modelWithKey:self.isBusiness value:@[@-1,@0] rule:RuleTypeBetween preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *betweenPredicate = [PredicateHelper predicateWithModelArray:@[betweenModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:betweenPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];

    
    //以...开始
    PredicateModel *beginModel = [PredicateModel modelWithKey:self.channel value:@"channel" rule:RuleTypeBeginsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *beginPredicate = [PredicateHelper predicateWithModelArray:@[beginModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:beginPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    
    //包含某些字符串
    PredicateModel *containModel = [PredicateModel modelWithKey:self.channel value:@"channel" rule:RuleTypeContains preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    
    NSPredicate *containPredicate = [PredicateHelper predicateWithModelArray:@[containModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:containPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //以...结束
    PredicateModel *endModel = [PredicateModel modelWithKey:self.channel value:@"1" rule:RuleTypeEndsWith preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *endPredicate = [PredicateHelper predicateWithModelArray:@[endModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:endPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 1);
    }];
    
    //like匹配
    PredicateModel *likeModel = [PredicateModel modelWithKey:self.channel value:@"*c*" rule:RuleTypeLike preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *likePredicate = [PredicateHelper predicateWithModelArray:@[likeModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:likePredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //matches匹配
    PredicateModel *matchesModel = [PredicateModel modelWithKey:self.channel value:@"^[a-zA-Z][a-zA-Z0-9_]*$" rule:RuleTypeMatches preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *matchesPredicate = [PredicateHelper predicateWithModelArray:@[matchesModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:matchesPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 10);
    }];
    
    //在多个值之间
    PredicateModel *inModel = [PredicateModel modelWithKey:self.isBusiness value:@[@-1,@0] rule:RuleTypeIn preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *inPredicate = [PredicateHelper predicateWithModelArray:@[inModel]];
    [CoreDataManager.shared querySyncWithTableName:self.tableName predicate:inPredicate sort:nil fetchResultHandler:^(NSArray * _Nullable result) {
        XCTAssertEqual(result.count, 5);
    }];
}


#pragma mark - 是否存在数据

- (void)testIsExist{
    [CoreDataManager.shared deleteWithTableName:self.tableName];
    
    PredicateModel *model = [PredicateModel modelWithKey:self.channel value:@"channel" rule:RuleTypeEqual preCondition:PreConditionTypeNone joinCondition:JoinConditionTypeNone];
    NSPredicate *predicate = [PredicateHelper predicateWithModelArray:@[model]];
    BOOL isExist = [CoreDataManager.shared isExistWithTableName:self.tableName predicate:predicate];
    XCTAssertEqual(isExist, false);
    
    NSDictionary *dict = @{
                           self.channel : @"channel",
                           self.avatarUrl : @"url",
                           self.company : @"companyName",
                           self.chatDate : [NSDate date],
                           self.nickname : @"nickname",
                           self.noReadNum : @0,
                           self.email : @"mail",
                           self.isBusiness : @1
                           };
    [CoreDataManager.shared insertWithTableName:self.tableName propertits:dict];
    BOOL afterIsExist = [CoreDataManager.shared isExistWithTableName:self.tableName predicate:predicate];
    XCTAssertEqual(afterIsExist, true);
    
}



@end
