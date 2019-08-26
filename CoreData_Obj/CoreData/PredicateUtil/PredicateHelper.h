//
//  PredicateHelper.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/16.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PredicateModel;

NS_ASSUME_NONNULL_BEGIN

/**
 便利的创建谓词对象 NSPredicate
 */
@interface PredicateHelper : NSObject

/**
 根据单个或多个条件查询
 @param modelArray PredicateModel 对象数组
 @return 谓词对象
 */
+ (NSPredicate *)predicateWithModelArray:(NSArray<PredicateModel *> *)modelArray;

@end

NS_ASSUME_NONNULL_END
