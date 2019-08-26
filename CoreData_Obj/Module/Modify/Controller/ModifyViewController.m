//
//  ModifyViewController.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "ModifyViewController.h"
#import "QueryTableViewCell.h"
#import "InsertViewController.h"
#import "ChatListDB.h"
#import "ChatListModel.h"
@interface ModifyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<ChatListModel *> *modelArray;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArray = [[ChatListDB.shared getChatListFromTable] mutableCopy];
    [self initSubViews];
}

#pragma mark - UI
- (void)initSubViews{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:QueryTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QueryTableViewCell.class)];
        tableView.tableFooterView = [[UIView alloc]init];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QueryTableViewCell.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChatListModel *model = [self.modelArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.needShowActionButton = YES;
    cell.actionTitle = @"修改";
    __weak __typeof(self) weakSelf = self;
    cell.actionBlock = ^{
        __strong __typeof(self) strongSelf = weakSelf;
        InsertViewController *vc = [[InsertViewController alloc]initWithModel:model isModify:true];
        [strongSelf.navigationController pushViewController: vc animated:YES];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

@end

