//
//  ViewController.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//


#import "ViewController.h"
#import "CoreDataManager.h"
#import "UserTable+CoreDataProperties.h"
#import "ChatListDB.h"
#import "TBShareDevice.h"
#import "ChatListModel.h"
#import "InsertViewController.h"
#import "DeleteViewController.h"
#import "ModifyViewController.h"
#import "QueryViewController.h"
#import "PredicateHelper.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *insertButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *modifyButton;
@property (nonatomic,strong) UIButton *queryButton;
@property (nonatomic,strong) UIStackView *stackView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

#pragma mark Action

- (void)insertAction:(UIButton *)sender{
    InsertViewController *vc = [[InsertViewController alloc]initWithModel:[[ChatListModel alloc]init] isModify:false];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteAction:(UIButton *)sender{
    DeleteViewController *vc = [[DeleteViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)modifyAction:(UIButton *)sender{
    ModifyViewController *vc = [[ModifyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)queryAction:(UIButton *)sender{
    QueryViewController *vc = [[QueryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UI

- (void)initSubViews{
    self.title = @"CoreData操作";
    self.view.backgroundColor = UIColor.whiteColor;
    CGFloat centerX = SCREEN_WIDTH/2;
    CGFloat btnWidth = 200;
    self.insertButton = ({
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"增加" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColor.redColor];
        [btn addTarget:self action:@selector(insertAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.deleteButton = ({
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn setBackgroundColor: UIColor.greenColor];
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.modifyButton = ({
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"修改" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColor.blueColor];
        [btn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.queryButton = ({
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"查询" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn setBackgroundColor: UIColor.yellowColor];
        [btn addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.stackView = ({
        UIStackView *stackView = [[UIStackView alloc]initWithFrame:CGRectMake(centerX-btnWidth/2, SCREEN_HEIGHT/3, btnWidth, SCREEN_HEIGHT/3)];
        stackView.backgroundColor = UIColor.blueColor;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 20;
        stackView.distribution = UIStackViewDistributionFillEqually;
        [stackView addArrangedSubview:self.insertButton];
        [stackView addArrangedSubview:self.deleteButton];
        [stackView addArrangedSubview:self.modifyButton];
        [stackView addArrangedSubview:self.queryButton];
        stackView;
    });
    [self.view addSubview:self.stackView];
    
}


@end
