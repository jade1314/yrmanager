//
//  TradeLoginViewController.h
//  PanGu
//
//  Created by Fll on 16/8/13.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "RootViewController.h"

@interface TradeLoginViewController : RootViewController

@property (nonatomic, strong) RootViewController *pushViewController;// 应该跳转的 ViewController
@property (nonatomic, strong) RootViewController *fromViewController;// 从哪个页面过来的

@property (nonatomic, strong) void(^backTradeLoginBlock)(void);//回调

@end
