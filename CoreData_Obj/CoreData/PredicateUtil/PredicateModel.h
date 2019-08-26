//
//  PredicateModel.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/16.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>

//规则类型
typedef NS_ENUM(NSUInteger, RuleType) {
    //基本比较
    RuleTypeEqual, //等于
    RuleTypeGreatThanOrEqual,//大于等于
    RuleTypeLessThanOrEqual,//小于等于
    RuleTypeGreatThan,//大于
    RuleTypeLessThan,//小于
    RuleTypeUnEqual,//不等于
    RuleTypeBetween,//在某个范围之间
    
    //字符串比较
    RuleTypeBeginsWith,// 以某些内容开始
    RuleTypeContains,// 包含某些内容
    RuleTypeEndsWith,// 以某些内容结束
    RuleTypeLike,//  匹配某些内容
    RuleTypeMatches,// 匹配正则表达式
   
   
    //聚合运算符
    RuleTypeIn,//左侧必须位于右侧指定的集合中
    
};
//前置条件类型
typedef NS_ENUM(NSUInteger, PreConditionType){
    PreConditionTypeNone = 0,//无前置条件,返回空字符串
    PreConditionTypeNot, //非   ！/ not
};

//连接条件类型
typedef NS_ENUM(NSUInteger, JoinConditionType) {
    JoinConditionTypeNone, //单个条件 默认返回空字符串
    JoinConditionTypeAnd = 1, //与   && / and
    JoinConditionTypeOr  //或   || / or
    
};



NS_ASSUME_NONNULL_BEGIN

/**
 根据传入的值 创建PredicateModel对象，
 被用于在PredicateHelper类中创建NSPredicate对象
 */
@interface PredicateModel : NSObject
//数据表的属性名
@property (nonatomic, copy) NSString *key;
//数据表中属性对应的值
@property (nonatomic, strong) id value;
//规则类型
@property (nonatomic, assign) RuleType rule;
//连接条件类型
@property (nonatomic, assign) JoinConditionType joinCondition;
//前置条件类型
@property (nonatomic, assign) PreConditionType preCondition;

/**
 规则类型字符串
 */
@property (nonatomic, copy) NSString *ruleString;
/**
 连接条件类型字符串
 */
@property (nonatomic, copy) NSString *joinConditionString;
/**
 前置条件类型字符串
 */
@property (nonatomic, copy) NSString *preConditionString;



/**
  根据数据表属性名 对应值 规则类型 前置条件类型 连接条件类型 返回模型对象

 @param key 属性
 @param value 属性对应值  eg：字符串类型@"1" 、数组类型@[@"1",@"111"]。
 @param rule 规则类型 =、 >、 >=、 <=、 <、 !=、 matches、 like、 beginswith、 endswith、 in、 between、 contains
 @param preCondition 前置条件类型 not 
 @param joinCondition 连接条件类型 and or
 @return 返回模型对象
 */
+ (instancetype)modelWithKey:(NSString *)key value:(id)value rule:(RuleType)rule preCondition:(PreConditionType)preCondition joinCondition:(JoinConditionType)joinCondition;


/**
 提供默认前置条件类型
 根据数据表属性名 对应值 规则类型  连接条件类型 返回模型对象
 @param key 属性
 @param value 属性对应值  eg：字符串类型@"1" 、数组类型@[@"1",@"111"]。
 @param rule 规则类型 =、 >、 >=、 <=、 <、 !=、 matches、 like、 beginswith、 endswith、 in、 between、 contains
 @param joinCondition 连接条件类型 and or
 @return 返回模型对象
 */
+ (instancetype)modelPreConditionNoneWithKey:(NSString *)key value:(id)value rule:(RuleType)rule joinCondition:(JoinConditionType)joinCondition;

@end

NS_ASSUME_NONNULL_END
