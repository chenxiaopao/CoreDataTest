//
//  InsertModel.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InsertModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;


+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content;
+ (NSMutableArray *)getData;

@end

NS_ASSUME_NONNULL_END
