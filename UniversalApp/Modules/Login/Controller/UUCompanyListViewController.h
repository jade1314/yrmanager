//
//  UUCompanyListViewController.h
//  UniversalApp
//
//  Created by 王玉 on 2018/3/24.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "LMJStaticTableViewController.h"

typedef void(^selectCompBlock)(LMJWordItem *);

@interface UUCompanyListViewController : LMJStaticTableViewController
@property (nonatomic,   copy) selectCompBlock compB;
@end
