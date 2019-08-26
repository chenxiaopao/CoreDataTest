//
//  InsertTableViewCell.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "InsertTableViewCell.h"

@interface InsertTableViewCell () <UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation InsertTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
    }
    return self;
}

- (void)setModel:(InsertModel *)model{
    self.titleLabel.text = model.title;
    self.contentTextField.text = model.content;
}

- (void)initSubViews{
    
    CGFloat labelWidth = 120;
    CGFloat labelHeight = 80;
    CGFloat margin = 10;
    self.separatorInset = UIEdgeInsetsMake(0, labelWidth+margin, 0, 0);
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(margin, margin, labelWidth, labelHeight-margin*2);
        label;
    });
    [self.contentView addSubview:self.titleLabel];
    self.contentTextField = ({
        UITextField *textField = [[UITextField alloc]init];
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"请输入内容";
        textField.frame = CGRectMake(labelWidth+margin*2, margin, SCREEN_WIDTH-CGRectGetMaxY(self.titleLabel.frame)-margin, labelHeight-margin*2);
        textField;
    });
    [self.contentView addSubview:self.contentTextField];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.forbidEdit){
        return false;
    }
    return true;
}
@end
