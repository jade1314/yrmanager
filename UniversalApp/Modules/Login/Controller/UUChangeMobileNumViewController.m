//
//  UUChangeMobileNumViewController.m
//  UniversalApp
//
//  Created by 王玉 on 2018/5/2.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUChangeMobileNumViewController.h"
#import "UUChangeMobileAndPasswordTableViewCell.h"
#import "CommitBtnTool.h"

@interface UUChangeMobileNumViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton *_commitBtn;
}

@end

@implementation UUChangeMobileNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void) createUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _commitBtn = [[CommitBtnTool alloc]initWithFrame:CGRectMake(0, kScreenHeight - NAV_HEIGHT - 45 - TABBAR_X_DIF_HEIGHT, kScreenWidth, 45) completion:^(UIButton *btn) {
        UUChangeMobileAndPasswordTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSDictionary *userData = [defaults valueForKey:KUserData];
        NSString *companyCode = [defaults valueForKey:KCompanyCode];
        if (_type == PageTypeMobile) {
            //更新手机号码
            NSString *requestStr = [NSString stringWithFormat:@"ChgVipTele/%@/%@/%@",companyCode,userData[@"Id"],cell.field.text];
            
            [self changeWithStr:requestStr];
        } else if (_type == PageTypePassword) {
            //更新密码
            NSString *requestStr = [NSString stringWithFormat:@"ChgVipPwd/%@/%@/%@",companyCode,userData[@"Id"],cell.field.text];
            [self changeWithStr:requestStr];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"验证失败，请重试" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        }
    } title:@"确  定" corner:5];
    _commitBtn.selected = NO;
    _commitBtn.userInteractionEnabled = YES;
    [self.view addSubview:_commitBtn];
}
//更改会员手机号接口:ChgVipTele/公司编号/会员编号/新手机号
//更改会员登陆密码接口:ChgVipPwd/公司编号/会员编号/新密码
- (void) changeWithStr:(NSString *)str {
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:str] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        
        NSLog(@"%@",dict);
        
        
        if ([dict[@"RetCode"] integerValue] == 1) {
            //修改成功
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:dict[@"RetMsg"] message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *titleArr = @[@[@"请输入密码",@"请再次输入密码"],@[@"请输入手机号码",@"请再次输入手机号码"]];
    UUChangeMobileAndPasswordTableViewCell *cell = [UUChangeMobileAndPasswordTableViewCell replaceTableViewCell:tableView];
    if (_type == PageTypeMobile) {
        cell.field.placeholder = titleArr[1][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"icons8-equity_security"];
    }else {
        cell.field.secureTextEntry = YES;
        cell.field.placeholder = titleArr[0][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"icons8-equity_security"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}



@end
