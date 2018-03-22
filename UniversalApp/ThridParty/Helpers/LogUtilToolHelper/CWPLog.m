//
//  CWPLog.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "CWPLog.h"
#import "DateHelper.h"

#define LOG_FILE_NAME @"AppRunLog.txt"

static NSString * logPath;

@implementation CWPLog

//Log路径
+ (NSString*) LLogPath
{
    if (!logPath)
    {
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        logPath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:LOG_FILE_NAME]];
    }
    
    return logPath;
}

//清除Log
+ (void) clearLog
{
    NSString * content = @"";
    
    NSString * fileName = [CWPLog LLogPath];
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
}

//将本地Log转为字符串数组
+ (NSArray*) getLogArray
{
    NSString * fileName = [CWPLog LLogPath];
    
    NSString *content = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
    NSMutableArray * newArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++)
    {
        NSString * item = [array objectAtIndex:i];
        if ([item length])
            [newArray addObject:item];
    }
    return (NSArray*)newArray;
}

//新加一条log
+ (void) log:(NSString*) msg
{
    NSString * logMessage = [NSString stringWithFormat:@"%@ %@", [DateHelper getNowTimeWithType:DateHelperTimeTextTypeCut], msg];
    
    NSString * fileName = [CWPLog LLogPath];
    
    FILE * f = fopen([fileName UTF8String], "at");
    
    fprintf(f, "%s\n", [logMessage UTF8String]);
    
    fclose (f);
}

@end
