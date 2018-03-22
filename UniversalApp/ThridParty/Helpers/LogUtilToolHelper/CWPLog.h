//
//  CWPLog.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWPLog : NSObject

//新加一条log
+ (void) log:(NSString*) msg;

//清除Log
+ (void) clearLog;

//将本地Log转为字符串数组
+ (NSArray*) getLogArray;

@end
