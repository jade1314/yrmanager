//
//  UsersModel.h
//  PanGu
//
//  Created by Fll on 16/8/17.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersModel : NSObject

@property (nonatomic, copy) NSString *userId;//主键1
//密码是否明文
@property (nonatomic, copy) NSString *isPassWord;
//是否进行双向认证
@property (nonatomic, copy) NSString *twowayAuthentication;
//下载插件是否成功
@property (nonatomic, copy) NSString *downloadPlugin;
//验证APP合法性
@property (nonatomic, copy) NSString *verifyLegitimacy;
//用户名2
@property (nonatomic, copy) NSString *userName;
//真实姓名3
@property (nonatomic, copy) NSString *realName;
//用户类型4
@property (nonatomic, copy) NSString *userType;
//注册账号
@property (nonatomic, copy) NSString *scno;
//账号类型（0:qq 1:微信 2:微博 3:手机）
@property (nonatomic, copy) NSString *typeScno;
//注册登录密码
@property (nonatomic, copy) NSString *passWord;
//交易账号（多个交易账号用逗号隔开存放在此字段）
@property (nonatomic, copy) NSString *tradeScno;
//手机号
@property (nonatomic, copy) NSString *mobile;
//手机号类型:1中国移动、2中国电信、3中国联通
@property (nonatomic, copy) NSString *mobileType;
//登录交易获得的token值5
@property (nonatomic, copy) NSString *token;
//身份卡片
@property (nonatomic, copy) NSString *idCard;
//身份id
@property (nonatomic, copy) NSString *identityId;
//是否在手机端安装并登录过?
@property (nonatomic, copy) NSString *mount;
//注册时间（手机或WEB）
@property (nonatomic, copy) NSString *regtime;
//注册来源（手机或WEB）
@property (nonatomic, copy) NSString *regChannel;
//是否签署过电子签名约定书
@property (nonatomic, copy) NSString *isArrange;
// 用户状态（默认为1001）：1001 最后登陆用户,1002 非最后登陆用户
@property (nonatomic, copy) NSString *userStatus;
//是否已经登陆
@property (nonatomic, copy) NSString *isLOGIN;
//是否注册  0是注册用户，1是未注册用户
@property (nonatomic, copy) NSString *isRegister;
//是否认证，0未认证  1已认证 针对服务器端的导入用户
@property (nonatomic, copy) NSString *realauth;
//昵称，不要求唯一
@property (nonatomic, copy) NSString *pickName;
//昵称的全拼（小写）
@property (nonatomic, copy) NSString *pinyin;
//个性签名 系统将该项信息保存为外部文本文件(Android 可以保存为XML)，此处为文件名； 命名：UID.signature
@property (nonatomic, copy) NSString *signature;
//性别    0男  1女
@property (nonatomic, copy) NSString *sex;
//用户头像原图地址
@property (nonatomic, copy) NSString *photo;
//头像压缩后的小图地址
@property (nonatomic, copy) NSString *zoomPhoto;
//背景地址
@property (nonatomic, copy) NSString *bgUrl;
//兴趣
@property (nonatomic, copy) NSString *interests;
//生日
@property (nonatomic, copy) NSString *birthdate;
//家乡
@property (nonatomic, copy) NSString *homeTown;
//宗教
@property (nonatomic, copy) NSString *religiousview;
//用户所在省份ID
@property (nonatomic, copy) NSString *provinceId;
//信用的登录状态
@property (nonatomic, copy) NSString *creditstatus;
//信用的账号
@property (nonatomic, copy) NSString *creditallaccounts;
//行情刷新时间
@property (nonatomic, copy) NSString *hqRefresh;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN00;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN01;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN02;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN03;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN04;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN05;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN06;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN07;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN08;
//预留
@property (nonatomic, copy) NSString *EXCOLUMN09;

@end
