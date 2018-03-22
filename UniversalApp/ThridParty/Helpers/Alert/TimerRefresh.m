//
//  TimerRefresh.m
//  PanGu
//
//  Created by 王玉 on 16/8/10.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//


#import "TimerRefresh.h"

@interface TimerRefresh ()
@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,assign) NSTimeInterval timeSumInterval;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) TimerUpdateBlock updateBlock;
@property (nonatomic,assign) BOOL isStart;
@end

@implementation TimerRefresh



+ (instancetype)pq_createTimerWithType:(PQ_TimerType)type updateInterval:(NSTimeInterval)interval repeatInterval:(NSTimeInterval)repeatInterval update:(TimerUpdateBlock)block{
    TimerRefresh * timerManager = [[self alloc] init];
    //多少秒更新一次
    timerManager.timeSumInterval = interval;
    //多少秒执行一次
    timerManager.repeatTime = repeatInterval;
    //保存block
    timerManager.updateBlock = block;
    //判断类型
    if(type == PQ_TIMERTYPE_CREATE_OPEN){
        [timerManager pq_open];
    }
    return timerManager;
}
/**
 *  打开
 */
- (void)pq_open{
    //开启之前先关闭定时器
    [self pq_close];
    //把计数器归零
    self.timeInterval = 0;
    //创建timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.repeatTime target:self selector:@selector(pq_timeUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.isStart = YES;
}
//更新时间
- (void)pq_timeUpdate{
    //如果不是开始 直接返回 并且归零计数器
    if (!self.isStart) {
        return;
    }
    self.timeInterval ++;
//    NSLog(@"%f",self.timeInterval);
    if (self.timeInterval == self.timeSumInterval) {
        self.timeInterval = 0;
        self.updateBlock();
    }
}

/**
 *  关闭
 */
- (void)pq_close{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
}
/**
 *  把时间设置为零
 */
- (void)pq_updateTimeIntervalToZero{
    self.timeInterval = 0;
}
/**
 *  更新现在的时间
 *
 *  @param interval
 */
- (void)pq_updateTimeInterval:(NSTimeInterval)interval{
    self.timeInterval = interval;
}

/**
 *  开机计数
 */
- (void)pq_start{
    self.isStart = YES;
}
/**
 *  暂停计数
 */
- (void)pq_pause{
    self.isStart = NO;
}
/**
 *  开始计时器
 */
- (void)pq_distantPast{
    [self.timer setFireDate:[NSDate distantPast]];
}
/**
 *  暂停计时器
 */
- (void)pq_distantFuture{
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
