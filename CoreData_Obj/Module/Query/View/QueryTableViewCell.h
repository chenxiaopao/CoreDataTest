//
//  QueryTableViewCell.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QueryTableViewCell : UITableViewCell
@property (nonatomic,strong) ChatListModel *model;
@property (nonatomic,assign) BOOL needShowActionButton;
@property (nonatomic,copy) NSString *actionTitle;
@property (nonatomic,copy) void(^actionBlock)(void);
@end

NS_ASSUME_NONNULL_END
