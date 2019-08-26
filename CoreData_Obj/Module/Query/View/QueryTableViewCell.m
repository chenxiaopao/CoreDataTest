//
//  QueryTableViewCell.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "QueryTableViewCell.h"
@interface QueryTableViewCell ()
@property (nonatomic,strong) UILabel *channelIdLabel;
@property (nonatomic,strong) UILabel *avatarUrlLabel;
@property (nonatomic,strong) UILabel *companyNameLabel;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UILabel *mailLabel;
@property (nonatomic,strong) UIButton *actionButton;
@end

@implementation QueryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
    }
    return self;
}
#pragma mark - Action
- (void)setNeedShowActionButton:(BOOL)needShowActionButton{
    _needShowActionButton = needShowActionButton;
    self.actionButton.hidden = !needShowActionButton;
}

- (void)setActionTitle:(NSString *)actionTitle{
    [self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
}

- (void)setModel:(ChatListModel *)model{
    _model = model;
    self.channelIdLabel.text = [NSString stringWithFormat:@"channelId:%@",model.accountId];
    self.avatarUrlLabel.text = [NSString stringWithFormat:@"avatarUrl:%@",model.avatarUrl];
    self.companyNameLabel.text = [NSString stringWithFormat:@"companyName:%@",model.companyName];
    self.nicknameLabel.text = [NSString stringWithFormat:@"nickname:%@",model.nickname];
    self.mailLabel.text = [NSString stringWithFormat:@"mail:%@",model.mail];
}

- (void)action:(UIButton *)sender{
    if(self.actionBlock){
        self.actionBlock();
    }
}

#pragma mark - UI
- (void)initSubViews{
    CGFloat margin = 10;
    CGFloat labelHeight = 30;
    CGFloat labelWidth = SCREEN_WIDTH - margin*2;
    
    self.channelIdLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"channelId:";
        label.frame = CGRectMake(margin, margin, labelWidth, labelHeight);
        label;
    });
    self.avatarUrlLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"avatarUrl:";
        label.frame = CGRectMake(margin, CGRectGetMaxY(self.channelIdLabel.frame)+margin, labelWidth, labelHeight);
        label;
    });
    self.companyNameLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"companyName:";
        label.frame = CGRectMake(margin, CGRectGetMaxY(self.avatarUrlLabel.frame)+margin, labelWidth, labelHeight);
        label;
    });
    self.nicknameLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"nickname:";
        label.frame = CGRectMake(margin, CGRectGetMaxY(self.companyNameLabel.frame)+margin, labelWidth, labelHeight);
        label;
    });
    self.mailLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"mail:";
        label.frame = CGRectMake(margin, CGRectGetMaxY(self.nicknameLabel.frame)+margin, labelWidth, labelHeight);
        label;
    });
    
    self.actionButton = ({
        UIButton *btn = [[UIButton alloc]init];
        btn.hidden = YES;
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(SCREEN_WIDTH-margin-60, CGRectGetMinY(self.mailLabel.frame), 60, 30);
        btn;
    });
    [self.contentView addSubview:self.actionButton];
    [self.contentView addSubview:self.channelIdLabel];
    [self.contentView addSubview:self.avatarUrlLabel];
    [self.contentView addSubview:self.companyNameLabel];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.mailLabel];
}

@end
