//
//  CoreDataManager.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoreDataManager, NSManagedObjectContext;
NS_ASSUME_NONNULL_BEGIN

typedef void (^CoreDataManagerBlock)(CoreDataManager *manager);
typedef void (^FetchResultHandlder)(NSArray * _Nullable result);


@interface CoreDataManager : NSObject

@property (nonatomic,copy,readonly) CoreDataManager *(^tableName)(NSString *tableName);
@property (nonatomic,copy,readonly) CoreDataManager *(^propertites)(NSDictionary *propertites);
@property (nonatomic,copy,readonly) CoreDataManager *(^sort)(NSSortDescriptor *sort);
@property (nonatomic,copy,readonly) CoreDataManager *(^predicate)(NSPredicate *predicate);
@property (nonatomic,copy,readonly) CoreDataManager *(^fetchHandler)(FetchResultHandlder handler);

+ (instancetype)shared;
- (NSManagedObjectContext *)context;

#pragma mark - 链式调用

+ (BOOL)insert:(CoreDataManagerBlock)block;
+ (BOOL)modify:(CoreDataManagerBlock)block;
+ (void)queryAsync:(CoreDataManagerBlock)block;
+ (void)querySync:(CoreDataManagerBlock)block;
+ (BOOL)deleteTable:(CoreDataManagerBlock)block;


#pragma mark - 普通传参

/**
 添加数据
 @param tableName 表名称 TableName
 @param propertits 插入的属性名和值 {key:value,key1:value1}
 */
- (BOOL)insertWithTableName:(NSString *)tableName propertits:(NSDictionary *)propertits;



/**
 异步查询表中全部数据
 @param tableName 表名称
 @param handler 将查询的结果回调
 */
- (void)queryAsyncWithTableName:(NSString *)tableName fetchResultHandler:(FetchResultHandlder)handler;

/**
 根据排序方式异步查询指定条件数据
 @param tableName 表名称
 @param predicate 谓词对象，设置查找条件。使用PredicateHelper 便利地创建NSPredicate对象
 @param sort 排序描述
 @param handler 将查询的结果回调
 */
- (void)queryAsyncWithTableName:(NSString *)tableName predicate:(nullable NSPredicate *)predicate sort:(nullable NSSortDescriptor *)sort fetchResultHandler:(FetchResultHandlder)handler;

/**
 同步查询指定条件数据
 @param tableName 表名称
 @param handler 将查询的结果回调
 */
- (void)querySyncWithTableName:(NSString *)tableName fetchResultHandler:(FetchResultHandlder)handler;

/**
 根据排序方式同步查询指定条件数据
 @param tableName 表名称
 @param predicate 谓词对象，设置查找条件。使用PredicateHelper 便利地创建NSPredicate对象
 @param sort 排序描述
 @param handler 将查询的结果回调
 */
- (void)querySyncWithTableName:(NSString *)tableName predicate:(nullable NSPredicate *)predicate sort:(nullable NSSortDescriptor *)sort fetchResultHandler:(FetchResultHandlder)handler;

/**
 删除全部数据
 @param tableName 表名称
 */
- (BOOL)deleteWithTableName:(NSString *)tableName;

/**
 删除指定条件数据
 @param tableName 表名称
 @param predicate 谓词对象，设置查找条件。使用PredicateHelper 便利地创建NSPredicate对象
 */
- (BOOL)deleteWithTableName:(NSString *)tableName predicate:(nullable NSPredicate *)predicate;




/**
 修改数据
 @param tableName 表名称 TableName
 @param predicate 谓词对象，设置查找条件。使用PredicateHelper 便利地创建NSPredicate对象
 @param propertites 插入的属性名和值 {key:value,key1:value1}
 */
- (BOOL)modifyWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate properties:(NSDictionary *)propertites;

/**
 是否存在数据
 @param tableName 表名称
 @param predicate 谓词对象，设置查找条件。使用PredicateHelper 便利地创建NSPredicate对象
 @return 是否存在
 */
- (BOOL)isExistWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate;
@end

NS_ASSUME_NONNULL_END
