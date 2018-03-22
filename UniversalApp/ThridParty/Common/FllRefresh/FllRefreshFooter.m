//
//  FllRefreshFooter.m
//  PanGu
//
//  Created by Fll on 16/6/23.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "FllRefreshFooter.h"
#import "Masonry.h"

@interface FllRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation FllRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 44;
    
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
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(isiPhoneX ? 20 : 0);
    }];
    [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.label.mas_left).offset(-10);
        make.centerY.equalTo(self.mas_centerY).offset(isiPhoneX ? 20 : 0);
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
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"上拉加载更多";
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.label.text = [NSString stringWithFormat:@"正在刷新 最后更新:%@",[self dateTime]];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            self.label.text = [NSString stringWithFormat:@"正在刷新 最后更新:%@",[self dateTime]];
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.label.text = @"没有更多数据";
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.label.textColor = [UIColor grayColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
