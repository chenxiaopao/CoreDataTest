//
//  InsertViewController.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/15.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "InsertViewController.h"
#import "InsertTableViewCell.h"
#import "ChatListDB.h"
#import "TBShareDevice.h"
#import "ChatListModel.h"
@interface InsertViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) UIButton *insertButton;
@property (nonatomic,strong) ChatListModel *model;
@property (nonatomic,assign) BOOL isModify;
@end

@implementation InsertViewController
- (instancetype)initWithModel:(ChatListModel *)model isModify:(BOOL)isModify{
    if (self = [super init]){
        self.model = model;
        self.isModify = isModify;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArray = [InsertModel getData];
    [self setData];
    [self initSubViews];
}

#pragma mark - UI
- (void)initSubViews{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:InsertTableViewCell.class forCellReuseIdentifier:NSStringFromClass(InsertTableViewCell.class)];
        tableView.tableFooterView = [[UIView alloc]init];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.insertButton = ({
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = UIColor.blueColor;
        btn.frame = CGRectMake(20, SCREEN_HEIGHT-100, SCREEN_WIDTH-40, 50);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        NSString *title = self.isModify ? @"修改" : @"添加";
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(insertAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:self.insertButton];
}

#pragma mark - Action

- (void)setData{
    if ([self.model.accountId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet].length > 0){
        InsertModel *model = [InsertModel modelWithTitle:@"channelId:" content:self.model.accountId];
        InsertModel *model1 = [InsertModel modelWithTitle:@"avatarUrl:" content:self.model.avatarUrl];
        InsertModel *model2 = [InsertModel modelWithTitle:@"companyName:" content:self.model.companyName];
        InsertModel *model3 = [InsertModel modelWithTitle:@"nickname:" content:self.model.nickname];
        InsertModel *model4 = [InsertModel modelWithTitle:@"mail:" content:self.model.mail];
        [self.modelArray removeAllObjects];
        [self.modelArray addObjectsFromArray:@[model,model1,model2,model3,model4]];
    }
}

- (void)insertAction:(UIButton *)sender{
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i=0; i<self.modelArray.count; i++) {
        InsertTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
        NSString *value = cell.contentTextField.text;
        [mArray addObject:value];
    }
    TBShareDevice *device = [TBShareDevice deviceWithChannel:mArray[0] avatarUrl:mArray[1] companyName:mArray[2] nickName:mArray[3] mail:mArray[4]];
    if (self.isModify){
        [ChatListDB.shared updateDateWithChannelId:self.model.accountId device:device];
    }else{
        [ChatListDB.shared insertChatListWithDevice:device];
    }
    
    
    //弹窗
    NSString *title = self.isModify ? @"修改成功" : @"添加成功";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (self.isModify){
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InsertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(InsertTableViewCell.class) forIndexPath:indexPath];
    cell.model = [self.modelArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isModify && indexPath.row == 0){
        cell.forbidEdit = true;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
