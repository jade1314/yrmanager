//
//  DateHelper.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

//enum _DateHelperTimeTextType { DateHelperTimeTextTypeCut= -1, DateHelperTimeTextTypeColon, DateHelperTimeTextTypeNone};
typedef NSInteger DateHelperTimeTextType;

@interface DateHelper : NSObject

/**
 *  是否为同一天
 */
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

//计算流逝的时间 参数为一个标准格式的时间字符串
+(NSString *) calulatePassTime:(NSString *) timeText;

+(NSString *) calulatePassTimeTZGG:(NSString *) timeText;
//根据类型返回时间
+(NSString *) getNowTimeWithType:(DateHelperTimeTextType) type;

//获取当前年份
+(NSString *) year;

//获取当前月份
+(NSString *) month;

//获取当月几号
+(NSString *) day;

//获取当前小时
+(NSString *) hour;

//获取当前分钟
+(NSString *) minite;

//获取当前年月日字符串
+(NSString *) yearMonthDayString;

//获取当前年月日数组
+(NSArray *) yearMonthDayArray;

//获取当前小时与分钟字符串
+(NSString *) hourMinitesString;

//获取当前小时与分钟数组
+(NSArray *) hourMinitesArray;


/********************/

//获取当前时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)currentTime;

//yyyyMMdd 转 yyyy.MM.dd
+ (NSString *)dateStrDotWithString:(NSString *)dateString;

//yyyyMMdd 转 yyyy-MM-dd
+ (NSString *)dateStrDashWithString:(NSString *)dateString;
//yyyyMMdd 转MM.dd
+ (NSString *)dateMDStrDashWithString:(NSString *)dateString;
//yyyy-MM-dd 转 MM.dd
+ (NSString *)dateMDStrDashWithMinusString:(NSString *)dateString;
//yyyyMMdd 转 MM-dd
+ (NSString *)dateMDStrHengDashWithMinusString:(NSString *)dateString;

+ (NSString *)dateStrObliqueLineWithString:(NSString *)dateString;

// yyyy/MM/dd 转 yyyyMMdd
+ (NSString *)dateStrLineWithString:(NSString *)dateString;
// yyyy-MM-dd 转 yyyyMMdd
+ (NSString *)dateStrNoneWithString:(NSString *)dateString;
//HHmmss 转 HH:mm:ss
+ (NSString *)timeStrColonWithString:(NSString *)timeString;

//string 转 date
+ (NSDate *)timeString:(NSString *)timeString;

//yyyy-MM-dd,yyyy.MM.dd yyyyMMdd转 MMdd
+ (NSString *)dateMDStrTotalString:(NSString *)dateString;
//yyyy-MM-dd,yyyy.MM.dd yyyyMMdd转date
+ (NSDate *)dateYMDStrTotalDate:(NSString *)dateString;

//yyyy-MM-dd HH:mm:ss 格式的当前时间
+ (NSString *)getDashNowDate;

// yyyy-MM-dd 转 yyyy.MM.dd
+ (NSString *)dateStrDotWithDashString:(NSString *)dateString;

+(NSString *)dateNumberConvertEnglish:(NSString *)dateString;

+ (NSDate *)dateFromLineString:(NSString *)lineStr;

+ (NSString *)dateStrWithTotalStr:(NSString *)totalStr;

@end

