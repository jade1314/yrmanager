//
//  DLLoading.h
//  MobileClassPhone
//
//  Created by songs on 14/12/29.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLLoadingView.h"

@interface DLLoading : NSObject

/*
 
 使用下列方法是在UIWindow上加载弹出框，因此会阻断交互
 
 DLLoadingInWindow:close:   弹出加载框
 title提示语句（可为nil），close有值表示可以手动取消弹出框（里面可执行取消之后事件），否则调用   DLHide  方法关闭弹出框
 
 DLToolTip:     是提示框
 title提示语句，统一1.5s之后消失，如有特殊需求，再开发消失时间
 
 DLHide     提示框消失
 
 */
+(void)DLToolTipInWindow:(NSString*)title interval:(NSTimeInterval)time;

+(void)DLLoadingInWindow:(NSString*)title close:(DLCloseLoadingView)close;

+(void)DLToolTipInWindow:(NSString*)title;

+(void)DLHideInWindow;

+(void)DLHideInWindowDelay:(NSInteger)delay;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
