//
//  InsertTableViewCell.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InsertTableViewCell : UITableViewCell

@property (nonatomic,strong) UITextField *contentTextField;
@property (nonatomic,strong) InsertModel *model;
@property (nonatomic,assign) BOOL forbidEdit;

@end

NS_ASSUME_NONNULL_END
