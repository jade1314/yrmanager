//
//  GYZCustomCalendarPickerView.h
//  GYZCalendarPicker
//
//  Created by GYZ on 16/6/22.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDJChineseCalendar.h"
#import "IDJCalendarUtil.h"
#import "GYZCommon.h"

@protocol InvestmentPickerViewDelegate;

@interface InvestmentPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, assign) id<InvestmentPickerViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;
-(void)show;
@end

@protocol InvestmentPickerViewDelegate <NSObject>
//通知使用这个控件的类，用户选取的日期
- (void)investmentCal:(NSString *)returnDay;
@end
