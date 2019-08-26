//
//  CoreDataManager.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CoreDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, copy) NSString *tableNameValue;
@property (nonatomic, copy) NSDictionary *propertitesValue;
@property (nonatomic, strong) NSSortDescriptor *sortValue;
@property (nonatomic, strong) NSPredicate *predicateValue;
@property (nonatomic, copy) FetchResultHandlder handlerValue;

@end

@implementation CoreDataManager

+ (instancetype)shared{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


#pragma mark - 添加数据

- (BOOL)insertWithTableName:(NSString *)tableName propertits:(NSDictionary *)propertits{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.context];
    for (NSString *key in propertits.allKeys) {
        id value = [propertits objectForKey:key];
        [entity setValue: value forKey:key];
    }
    NSError *error = nil;
    if (![self.context save:&error]){
        NSLog(@"%@",error);
        return false;
    }else{
        return true;
    }
}


#pragma mark - 查询数据

- (void)queryAsyncWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate sort:(nullable NSSortDescriptor *)sort fetchResultHandler:(FetchResultHandlder)handler{
    
    NSFetchRequest *fetchRequst = [NSFetchRequest fetchRequestWithEntityName:tableName];
    fetchRequst.predicate = predicate;
    if (sort.key != nil){
        fetchRequst.sortDescriptors = @[sort];
    }
    NSAsynchronousFetchRequest *asyncFetchRequst = [[NSAsynchronousFetchRequest alloc]initWithFetchRequest:fetchRequst completionBlock:^(NSAsynchronousFetchResult * result) {
        NSArray *rst = result.finalResult;
        handler(rst);
    }];
    
    NSError *error = nil;
    if (![self.context executeRequest:asyncFetchRequst error:&error]){
        NSLog(@"%@",error);
    }
}
- (void)queryAsyncWithTableName:(NSString *)tableName fetchResultHandler:(FetchResultHandlder)handler{
    [self queryAsyncWithTableName:tableName predicate:nil sort:[[NSSortDescriptor alloc]init] fetchResultHandler:handler];
}

- (void)querySyncWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate sort:(nullable NSSortDescriptor *)sort fetchResultHandler:(FetchResultHandlder)handler{
    
    NSFetchRequest *fetchRequst = [NSFetchRequest fetchRequestWithEntityName:tableName];
    
    fetchRequst.predicate = predicate;
    
    if (sort.key != nil){
        fetchRequst.sortDescriptors = @[sort];
    }
    
    NSError *error = nil;
    NSArray * result = [self.context executeFetchRequest:fetchRequst error:&error];
    if (![self.context save:&error]){
        NSLog(@"%@",error);
    }
    handler(result);
}

- (void)querySyncWithTableName:(NSString *)tableName fetchResultHandler:(FetchResultHandlder)handler{
    [self querySyncWithTableName:tableName predicate:nil sort:[[NSSortDescriptor alloc]init] fetchResultHandler:handler];
}


#pragma mark - 删除数据

- (BOOL)deleteWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate{
    NSError *error = nil;
    NSFetchRequest *fetchRequst = [NSFetchRequest fetchRequestWithEntityName:tableName];
    fetchRequst.predicate = predicate;

    NSMutableArray *result = [[self.context executeFetchRequest:fetchRequst error:&error] mutableCopy];
    for (id obj in result) {
        [self.context deleteObject:obj];
    }
    if (![self.context save:&error]){
        NSLog(@"%@",error);
        return false;
    }else{
        return true;
    }
}
- (BOOL)deleteWithTableName:(NSString *)tableName{
    return [self deleteWithTableName:tableName predicate:nil];
}


#pragma mark - 修改数据

- (BOOL)modifyWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate properties:(NSDictionary *)propertites{
    NSError *error = nil;
    NSFetchRequest *fetchRequst = [NSFetchRequest fetchRequestWithEntityName:tableName];
    fetchRequst.predicate = predicate;
    NSMutableArray *result = [[self.context executeFetchRequest:fetchRequst error:&error] mutableCopy];
    for (id obj in result) {
        for (NSString *key in propertites.allKeys) {
            id value = [propertites objectForKey:key];
            [obj setValue:value forKey:key];
        }
    }
    if (![self.context save:&error]){
        NSLog(@"%@",error);
        return false;
    }else{
        return true;
    }
}


#pragma mark - 是否存在

- (BOOL)isExistWithTableName:(NSString *)tableName predicate:(NSPredicate *)predicate{
    __block BOOL isExist = false;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]init];
    [self querySyncWithTableName:tableName predicate:predicate sort:sort fetchResultHandler:^(NSArray * _Nullable result) {
        isExist = result.count > 0;
    }];
    return isExist;
}

#pragma mark - Getter
- (NSManagedObjectContext *)context{
    if (!_context){
        AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        _context = delegate.persistentContainer.viewContext;
    }
    return _context;
}


#pragma mark - 链式调用

- (CoreDataManager * _Nonnull (^)(NSString * _Nonnull))tableName{
    return ^CoreDataManager *(NSString *tableName){
        self.tableNameValue = tableName;
        return self;
    };
}

- (CoreDataManager * _Nonnull (^)(NSDictionary * _Nonnull))propertites{
    return ^CoreDataManager *(NSDictionary *propertites){
        self.propertitesValue = propertites;
        return self;
    };
}

- (CoreDataManager * _Nonnull (^)(NSSortDescriptor * _Nonnull))sort{
    return ^CoreDataManager *(NSSortDescriptor *sort){
        self.sortValue = sort;
        return self;
    };
}

- (CoreDataManager * _Nonnull (^)(NSPredicate * _Nonnull))predicate{
    return ^CoreDataManager *(NSPredicate *predicate){
        self.predicateValue = predicate;
        return self;
    };
}

- (CoreDataManager * _Nonnull (^)(FetchResultHandlder _Nonnull))fetchHandler{
    return ^CoreDataManager *(FetchResultHandlder fetchHandler){
        self.handlerValue = fetchHandler;
        return self;
    };
}

+ (BOOL)insert:(CoreDataManagerBlock)block{
    CoreDataManager *mana = CoreDataManager.shared;
    [mana resetData];
    block ? block(mana) : nil;
    return [mana insertWithTableName:mana.tableNameValue propertits:mana.propertitesValue];
}

+ (BOOL)modify:(CoreDataManagerBlock)block{
    CoreDataManager *mana = CoreDataManager.shared;
    [mana resetData];
    block ? block(mana) : nil;
    return [mana modifyWithTableName:mana.tableNameValue predicate:mana.predicateValue properties:mana.propertitesValue];
}

+ (void)queryAsync:(CoreDataManagerBlock)block{
    CoreDataManager *mana = CoreDataManager.shared;
    [mana resetData];
    block ? block(mana) : nil;
    [mana queryAsyncWithTableName:mana.tableNameValue predicate:mana.predicateValue sort:mana.sortValue fetchResultHandler:mana.handlerValue];
}

+ (void)querySync:(CoreDataManagerBlock)block{
    CoreDataManager *mana = CoreDataManager.shared;
    [mana resetData];
    block ? block(mana) : nil;
    [mana querySyncWithTableName:mana.tableNameValue predicate:mana.predicateValue sort:mana.sortValue fetchResultHandler:mana.handlerValue];
}

+ (BOOL)deleteTable:(CoreDataManagerBlock)block{
    CoreDataManager *mana = CoreDataManager.shared;
    [mana resetData];
    block ? block(mana) : nil;
    return [mana deleteWithTableName:mana.tableNameValue predicate:mana.predicateValue];
}

- (void)resetData{
    CoreDataManager *manager = CoreDataManager.shared;
    manager.tableNameValue = nil;
    manager.propertitesValue = nil;
    manager.sortValue = nil;
    manager.predicateValue = nil;
    manager.handlerValue = nil;
}
@end
