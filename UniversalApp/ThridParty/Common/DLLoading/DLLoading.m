//
//  DLLoading.m
//  MobileClassPhone
//
//  Created by songs on 14/12/29.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "DLLoading.h"

@implementation DLLoading
{
    DLLoadingView *_loadingView;
}

+ (instancetype)sharedManager
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

+(void)DLLoadingInWindow:(NSString*)title close:(DLCloseLoadingView)close;
{
    DLLoadingView *loadingView = [[self sharedManager] getDLLoadingView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.height < 50) {
        return;
    }
    [loadingView showLoading:title close:close inView:window];
}

+(void)DLToolTipInWindow:(NSString*)title
{
    DLLoadingView *loadingView = [[self sharedManager] getDLLoadingView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (window.height < 50) {
        return;
    }
    [loadingView showToolTip:title interval:3.0 inView:window];
}

+(void)DLToolTipInWindow:(NSString*)title interval:(NSTimeInterval)time {
    DLLoadingView *loadingView = [[self sharedManager] getDLLoadingView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.height < 50) {
        return;
    }
    [loadingView showToolTip:title interval:time inView:window];
}

+(void)DLHideInWindow
{
    [[[self sharedManager] getDLLoadingView] removeFromSuperview];
}

+(void)DLHideInWindowDelay:(NSInteger)delay
{
    [DLLoading performSelector:@selector(DLHideInWindow) withObject:nil afterDelay:delay];
}

-(DLLoadingView*)getDLLoadingView
{
    if (!_loadingView) {
        _loadingView = [DLLoadingView new];
    }
    return _loadingView;
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

@end
