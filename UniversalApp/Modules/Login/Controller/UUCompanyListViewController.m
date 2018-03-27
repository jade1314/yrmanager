//
//  UUCompanyListViewController.m
//  UniversalApp
//
//  Created by 王玉 on 2018/3/24.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUCompanyListViewController.h"

@interface UUCompanyListViewController ()

@end

@implementation UUCompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uWeakSelf
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:@"complist/all"] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        
        NSString *compStr = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        
        NSData *data = [compStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *compArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *itemArr = [NSMutableArray new];
        for (NSDictionary *dict  in compArr) {
            LMJWordItem *item = [LMJWordItem itemWithTitle:dict[@"CompName"] subTitle:dict[@"CompID"] itemOperation:^(NSIndexPath *indexPath) {
                _compB(itemArr[indexPath.row]);
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [itemArr addObject:item];
        }
        
        NSLog(@"%@",compArr);
        
        [weakSelf.sections addObject:[LMJItemSection sectionWithItems:itemArr andHeaderTitle:@"选择公司" footerTitle:@"没有了"]];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
