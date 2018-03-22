//
//  TradeLoginStartViewController.h
//  PanGu
//
//  Created by Fll on 16/8/17.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "RootViewController.h"

@interface TradeLoginStartViewController : RootViewController

@property (nonatomic, strong) RootViewController *pushViewController;// 应该跳转的 ViewController
@property (nonatomic, strong) RootViewController *fromViewController;// 从哪个页面过来的
@property (nonatomic, assign) BOOL loginType;//判断进入交易登录界面是进哪一个界面

@property (nonatomic, strong) void(^backTradeLoginStartBlock)(void);//回调

@end
