//
//  PredicateModel.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/16.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "PredicateModel.h"

@implementation PredicateModel

+ (instancetype)modelWithKey:(NSString *)key value:(id)value rule:(RuleType)rule preCondition:(PreConditionType)preCondition joinCondition:(JoinConditionType)joinCondition{
    PredicateModel *model = [[PredicateModel alloc]init];
    model.key = key;
    model.value = value;
    model.rule = rule;
    model.preCondition = preCondition;
    model.joinCondition = joinCondition;
    return model;
}

+ (instancetype)modelPreConditionNoneWithKey:(NSString *)key value:(id)value rule:(RuleType)rule joinCondition:(JoinConditionType)joinCondition{
    return [self modelWithKey:key value:value rule:rule preCondition:PreConditionTypeNone joinCondition:joinCondition];
}

////基本比较
//RuleTypeEqual,
//RuleTypeGreatThanOrEqual,
//RuleTypeLessThanOrEqual,
//RuleTypeGreatThan,
//RuleTypeLessThan,
//RuleTypeUnEqual,
//RuleTypeBetween,
//
////字符串比较
//RuleTypeBeginsWith,
//RuleTypeContains,
//RuleTypeEndsWith,
//RuleTypeLike,
//RuleTypeMatches,


- (NSString *)ruleString{
    switch (self.rule) {
        case RuleTypeEqual:
            return @" = ";
            break;
        case RuleTypeGreatThanOrEqual:
            return @" >= ";
            break;
        case RuleTypeLessThanOrEqual:
            return @" <= ";
            break;
        case RuleTypeGreatThan:
            return @" > ";
            break;
        case RuleTypeLessThan:
            return @" < ";
            break;
        case RuleTypeUnEqual:
            return @" != ";
            break;
        case RuleTypeBetween:
            return @" between ";
            break;
        case RuleTypeBeginsWith:
            return @" beginswith ";
            break;
        case RuleTypeContains:
            return @" contains ";
            break;
        case RuleTypeEndsWith:
            return @"endswith";
            break;
        case RuleTypeLike:
            return @" like ";
            break;
        case RuleTypeMatches:
            return @" matches ";
            break;
        case RuleTypeIn:
            return @" in ";
            break;

        default:
            break;
    }

}


- (NSString *)preConditionString{
    switch (self.preCondition) {
        case PreConditionTypeNot:
            return @" not ";
            break;
        case PreConditionTypeNone:
            return @"";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)joinConditionString{
    switch (self.joinCondition) {
        case JoinConditionTypeAnd:
            return @"  and  ";
            break;
         
        case JoinConditionTypeOr:
            return @"  or  ";
            break;

        case JoinConditionTypeNone:
            return @"";
            break;

        default:
            break;
    }
}
@end
