//
//  UserInfo.m
//  MiAiApp
//
//  Created by JadeM on 2017/5/23.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (UserInfo *)initData:(NSDictionary *)dict {
    UserInfo *info = [UserInfo new];
    [info initDict:dict];
    return info;
}

- (void)initDict:(NSDictionary *)dict {
    _userid = [dict[@"Id"] integerValue];//用户ID
    _idcard = dict[@"Name"] ;//展示用的用户ID
    _photo = dict[@"Name"];//头像
    _nickname = dict[@"Name"];//昵称
    _sex = [dict[@"Id"] integerValue];//性别
    _imId = dict[@"Name"];//IM账号
    _imPass = dict[@"Name"];//IM密码
    _degreeId = [dict[@"Id"] integerValue];//用户等级
    _signature = dict[@"Name"];//个性签名
    _token = dict[@"Name"];//用户登录后分配的登录Token
    _info = dict[@"Name"];//游戏数据
    
}
@end
