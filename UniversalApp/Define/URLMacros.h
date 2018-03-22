//
//  URLMacros.h
//  MiAiApp
//
//  Created by JadeM on 2017/5/18.
//  Copyright © 2017年 JadeM. All rights reserved.
//



#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/
#define URL_main @"http://192.168.20.31:20000/shark-miai-service"
//#define URL_main @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define URL_main @"http://192.168.20.31:20000/shark-miai-service"

#elif ProductSever

/**生产服务器*/
#define URL_main @"http://192.168.20.31:20000/shark-miai-service"
#endif



#pragma mark - ——————— 详细接口地址 ————————

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"


#pragma mark - ——————— 用户相关 ————————
//自动登录
#define URL_user_auto_login @"/api/autoLogin"
//登录
#define URL_user_login @"/api/login"
//用户详情
#define URL_user_info_detail @"/api/user/info/detail"
//修改头像
#define URL_user_info_change_photo @"/api/user/info/changephoto"
//注释
#define URL_user_info_change @"/api/user/info/change"


// 登陆信息
#define USER_ID                     @"userId"
// 消息远程推送
#define USER_TOKEN                  @"USER_TOKEN"
// 判断已经登陆
#define USER_LOGIN                  @"USER_LOGIN"
// 首次登陆
#define USER_FIRST_TIME_LOGIN       @"user_first_time_login"

// 到价提醒
#define TO_REMIND_TIME              @"to_remind_time"
// 新股申购
#define NEW_SHARES_TIME             @"new_shares_time"
// 通知公告
#define ANNOUNCEMENTS_TIME          @"snnouncements_time"
// 成交事件
#define CLINCH_DEAL_TIME            @"clinch_deal_time"
// 银证转账
#define BANK_TRANSFER_TIME          @"bank_transfer_time"

// 用户站点测速之后
#define PORT_NUM                    @"port_num"
// 交易站点
#define PORT_NUM_TRADE              @"port_num_trade"
// note 服务
#define REGISTER_NOTE               @"register_note"
// httpserver 服务
#define REGISTER_HTTPS_ERVER        @"register_http_server"
// 用户点击过首页显示全部按钮
#define USER_FIRST_Reveal_All       @"user_first_reveal_all"
// 今日第一次登录
#define USER_HISTORY_TIME_LOGIN     @"user_history_time_login"
// 用来判断新股提示
#define USER_TODAY_ALERT_NEWSHARE   @"user_today_alert_newshare"
// 存交易登录之后的股东账号
#define TRADE_SHARE_HOLDER_LIST     @"trade_share_holder_list"
// 存信用交易登录之后的股东账号
#define CREDIT_TRADE_SHARE_HOLDER_LIST @"credit_trade_share_holder_list"

#define SCATCHABLE_LATEX_CONTENT    @"scatchable_latex_content"

#define NEWEditColumn               @"newInfoEditColumn"

// 首页通知数据(必须 Array 格式)
#define HOME_NOTICE_DATA            @"home_notice_data"

#endif /* URLMacros_h */
