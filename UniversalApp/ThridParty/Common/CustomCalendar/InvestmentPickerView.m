//
//  GYZCustomCalendarPickerView.m
//  GYZCalendarPicker
//
//  Created by GYZ on 16/6/22.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "InvestmentPickerView.h"

@interface InvestmentPickerView ()

@property (nonatomic, strong)NSMutableArray *days;
@end

@implementation InvestmentPickerView{
    UIPickerView    *_pickerView;
    UILabel         *_titleLabel;
    UIView *_datePickerView;//datePicker背景
    UIButton *_calendarBtn;

    
//    IDJCalendar *cal;
    NSString *returnDay;
}

- (instancetype)initWithTitle:(NSString *)title{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = kColor(0, 0, 0, 0.4);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tapGesture];
        [self createView:title];
    }
    
    return self;
}
-(void)createView:(NSString *)title{
    //生成日期选择器
    _datePickerView=[[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT(self)-306,WIDTH(self),305)];
    _datePickerView.backgroundColor=[UIColor whiteColor];
    _datePickerView.userInteractionEnabled = YES;
    [self addSubview:_datePickerView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewClick)];
    [_datePickerView addGestureRecognizer:tapGesture];
    
    UIButton *dateCancleButton=[[UIButton alloc] initWithFrame:CGRectMake(PADDING,0,44,44)];
    [dateCancleButton addTarget:self action:@selector(dateCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [dateCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [dateCancleButton.titleLabel setFont:k15Font];
    [dateCancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_datePickerView addSubview:dateCancleButton];
    
    UIButton *dateConfirmButton=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH(self)-44 - PADDING,Y(dateCancleButton),WIDTH(dateCancleButton),HEIGHT(dateCancleButton))];
    [dateConfirmButton addTarget:self action:@selector(dateConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [dateConfirmButton.titleLabel setFont:k15Font];
    [dateConfirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_datePickerView addSubview:dateConfirmButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(dateCancleButton), Y(dateCancleButton), kScreenWidth - MaxX(dateCancleButton)*2, HEIGHT(dateCancleButton))];
    _titleLabel.font = k15Font;
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_datePickerView addSubview:_titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(dateCancleButton), WIDTH(self), kLineHeight)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [_datePickerView addSubview:lineView];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MaxY(lineView) , WIDTH(lineView), 216)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [_datePickerView addSubview:_pickerView];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(_pickerView), WIDTH(lineView), kLineHeight)];
    lineView1.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [_datePickerView addSubview:lineView1];
    _calendarBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)*0.75, MaxY(lineView1), WIDTH(self)*0.25, HEIGHT(dateCancleButton))];
    [_pickerView reloadAllComponents];
}

#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 28;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    //设置日期字体
    [mycom1 setFont:[UIFont systemFontOfSize:18]];
    
    int day=[[self.days objectAtIndex:row]intValue];
    mycom1.text = [NSString stringWithFormat:@"%d日",day];
    return mycom1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return (kScreenWidth-100)/3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    returnDay = [[_days objectAtIndex:row] stringValue];
}

//填充天数
- (NSMutableArray *)days{
    if (nil == _days) {
        _days = [[NSMutableArray alloc]init];
        for (int i = 1; i < 29; i ++) {
            [_days addObject:@(i)];
        }
    }
    return _days;
}

- (void)show {
    UIWindow *window = APP_DELEGATE_INSTANCE.window;
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide {
    [self removeAnimation];
}

- (void)addAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_datePickerView setFrame:CGRectMake(0, self.frame.size.height - _datePickerView.frame.size.height, kScreenWidth, _datePickerView.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        [_datePickerView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

//确定选择
-(void)dateConfirmClick{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(investmentCal:)] == YES) {
            [self.delegate investmentCal:returnDay];
        }
    }
    
    [self removeAnimation];
}
//取消选择
-(void)dateCancleClick{
    [self removeAnimation];
}

-(void)pickerViewClick{
    
}

@end
