//
//  RootWebViewController.h
//  MiAiApp
//
//  Created by JadeM on 2017/5/18.
//  Copyright © 2017年 JadeM. All rights reserved.
//  webview 基类

#import "XLWebViewController.h"

@interface RootWebViewController : XLWebViewController

//在多级跳转后，是否在返回按钮右侧展示关闭按钮
@property(nonatomic,assign) BOOL isShowCloseBtn;
@end

