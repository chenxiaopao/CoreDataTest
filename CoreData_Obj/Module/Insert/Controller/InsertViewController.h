//
//  InsertViewController.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatListModel;
NS_ASSUME_NONNULL_BEGIN

@interface InsertViewController : UIViewController
- (instancetype)initWithModel:(ChatListModel *)model isModify:(BOOL)isModify;
@end

NS_ASSUME_NONNULL_END
