//
//  FllRefreshHeader.m
//  MJRefreshExample
//  下拉刷新
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "FllRefreshHeader.h"
#import "Masonry.h"
@interface FllRefreshHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation FllRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 44 ;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    [self.label sizeToFit];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat titleWidth = [ToolHelper sizeForNoticeTitle:@"正在刷新 最后更新:2016-88-00 04:55:49" font:[UIFont systemFontOfSize:12]].width;
//        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-(kScreenWidth-10-7-titleWidth)/2);
    }];
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(self.view.mas_left).offset(100);
//        make.right.mas_equalTo(self.view.mas_right).offset(-100);
//        make.top.mas_equalTo(self.view.mas_top).offset(50 + 80 * i);
//        make.height.equalTo(@(50));
//        
//        //multipliedBy成倍的
//    }];
    [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(-7);
//        make.top.equalTo(self.mas_top).offset(15);
//        make.size.mas_offset(CGSizeMake(5, self.mj_h * 0.5));
//        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 获取当前时间
-(NSString *)dateTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    [self.loading stopAnimating];
    self.label.text = [NSString stringWithFormat:@"正在刷新 最后更新:%@",[self dateTime]];
    [self.loading startAnimating];
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    self.label.textColor = [UIColor grayColor];
}

@end
