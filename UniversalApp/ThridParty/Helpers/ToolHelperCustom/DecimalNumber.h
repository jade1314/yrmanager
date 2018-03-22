//
//  DecimalNumber.h
//  PanGu
//
//  Created by jade on 16/12/22.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecimalNumber : NSObject

//保留2位小数  不四舍五入
+ (NSString *)decimalTwoNumber:(NSString *)str;

//处理保留3位小数
+ (NSString *)decimalThreeNumber:(NSString *)str ;

//处理保留4位小数
+ (NSString *)decimalFourthNumber:(NSString *)str;

//保留3位小数  四舍五入
+ (NSString *)decimalThreeNumberRound:(NSString *)str;

//保留4位小数  四舍五入
+ (NSString *)decimalFourthNumberRound:(NSString *)str;

@end
