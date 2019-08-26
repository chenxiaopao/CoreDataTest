//
//  PredicateHelper.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/16.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "PredicateHelper.h"
#import "PredicateModel.h"

@implementation PredicateHelper

+ (NSPredicate *)predicateWithModelArray:(NSArray<PredicateModel *> *)modelArray{
    
    __block NSMutableString *mString = [NSMutableString string];
    __block NSMutableArray *mArray = [NSMutableArray array];
    [modelArray enumerateObjectsUsingBlock:^(PredicateModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果是第一个元素，不添加条件类型 and 、or
        if ( idx != 0){
            [mString appendString:model.joinConditionString];
        }
        
        [mString appendString:model.preConditionString];
        [mString appendString:model.key];
        [mString appendString:@" "];
        [mString appendString:model.ruleString];
        
        //如果PredicateModel的值为数组,另做处理
        if ([model.value isKindOfClass:NSArray.class]){
            NSArray *valueArray = model.value;
            if (valueArray.count > 0){
                [mString appendString:@" { "];
                for (int i = 0; i<valueArray.count; i++) {
                    [mString appendString:@" %@,"];
                    [mArray addObject:valueArray[i]];
                }                
                mString = [NSMutableString stringWithString:[mString substringToIndex:mString.length-1]];
                [mString appendString:@" } "];
            }
        }else{
            //如果PredicateModel的值为其他值,直接添加
            [mString appendString:@" %@ "];
            [mArray addObject:model.value];
        }
        
    }];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:mString argumentArray:mArray];
    return predicate;
}

@end
