//
//  InsertModel.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "InsertModel.h"

@implementation InsertModel

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content{
    InsertModel *model = [[InsertModel alloc]init];
    model.title = title;
    model.content = content;
    return model;
}
//@property (nonatomic,copy) NSString *accountId;
//@property (nonatomic,copy) NSString *nickname;
//@property (nonatomic,copy) NSString *companyName;
//@property (nonatomic,copy) NSString *avatarUrl;
//@property (nonatomic,copy) NSString *chatDate;
//@property (nonatomic,copy) NSString *mail;
//@property (nonatomic,assign) BOOL isBusiness;

+ (NSMutableArray *)getData{
    NSMutableArray *mArray = [NSMutableArray array];
    InsertModel *model = [InsertModel modelWithTitle:@"channelId:" content:@""];
    InsertModel *model1 = [InsertModel modelWithTitle:@"avatarUrl:" content:@""];
    InsertModel *model2 = [InsertModel modelWithTitle:@"companyName:" content:@""];
    InsertModel *model3 = [InsertModel modelWithTitle:@"nickname:" content:@""];
    InsertModel *model4 = [InsertModel modelWithTitle:@"mail:" content:@""];
    [mArray addObjectsFromArray:@[model,model1,model2,model3,model4]];
    return mArray;
}

@end
