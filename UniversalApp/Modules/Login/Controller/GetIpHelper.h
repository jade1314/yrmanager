//
//  GetIpHelper.h
//  PanGu
//
//  Created by 陈伟平 on 2017/4/22.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetIpHelper : NSObject

+(void)urlRequestOperation:(void(^)(NSString *str))block failure:(void(^)(void))failureBlock;

+(NSDictionary *)deviceWANIPAdress;
//获取设备当前网络IP地址
+(NSString *)getIPAddress:(BOOL)preferIPv4;

@end
