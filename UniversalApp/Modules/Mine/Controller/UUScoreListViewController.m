//
//  UUScoreListViewController.m
//  UniversalApp
//
//  Created by 王玉 on 2018/3/26.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUScoreListViewController.h"

@interface UUScoreListViewController ()

@end

@implementation UUScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.lmj_navgationBar.hidden = YES;
}

- (void)createUI {
    self.title = @"积分明细";
    NSMutableArray *itemArr = [NSMutableArray new];
    for (NSDictionary *dict  in _scoreData) {
        LMJWordItem *item = [LMJWordItem itemWithTitle:dict[@"类型"] subTitle:[dict[@"积分余额"] stringValue] itemOperation:^(NSIndexPath *indexPath) {
            
            [UIAlertController mj_showActionSheetWithTitle:@"积分详情" message:@"仅供参考，如有需要请联系客服！" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                NSDictionary *dict = _scoreData[indexPath.row];
                
                NSString *str1 = [NSString stringWithFormat:@"积分余额:%@",[dict[@"积分余额"] stringValue]];
                NSString *str2 = [NSString stringWithFormat:@"类型:%@",dict[@"类型"]];
                NSString *str3 = [NSString stringWithFormat:@"相关金额:%@",dict[@"相关金额"]];
                NSString *str4 = [NSString stringWithFormat:@"积分:%@",[dict[@"积分"] stringValue]];
                NSString *str5 = [NSString stringWithFormat:@"备注:%@",dict[@"备注"]];
                NSString *str6 = [NSString stringWithFormat:@"日期:%@",dict[@"日期"]];
                alertMaker.addActionDefaultTitle(@"积分详情").addActionDefaultTitle(str1).addActionDefaultTitle(str2).addActionDefaultTitle(str3).addActionDefaultTitle(str4).addActionDefaultTitle(str5).addActionDefaultTitle(str6).addActionCancelTitle(@"取消");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            }];
        }];
        [itemArr addObject:item];
    }
    [self.sections addObject:[LMJItemSection sectionWithItems:itemArr andHeaderTitle:@"点击查看详情！" footerTitle:@"没有了"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

