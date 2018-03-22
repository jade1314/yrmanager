//
//  LLARingSpinnerView.m
//  LLARingSpinnerView
//
//  Created by Lukas Lipka on 05/04/14.
//  Copyright (c) 2014 Lukas Lipka. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#ifdef DEBUG
#define NLog(format, ...) NSLog(format, ## __VA_ARGS__)

#else
#define NLog(format, ...)
#endif

#import "LLARingSpinnerView.h"

static NSString *kLLARingSpinnerAnimationKey = @"llaringspinnerview.rotation";

@interface LLARingSpinnerView ()

@property (nonatomic, readonly) CAShapeLayer *progressLayer;
@property (nonatomic, readwrite) BOOL isAnimating;

@end

@implementation LLARingSpinnerView

@synthesize progressLayer = _progressLayer;
@synthesize isAnimating = _isAnimating;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self.layer addSublayer:self.progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)setCircleColor:(UIColor *)circleColor {
    self.progressLayer.strokeColor = circleColor.CGColor;
}

- (void)startAnimating {
    if (self.isAnimating)
        return;
    
    [self addObserver];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 1.0f;
    animation.fromValue = @(0.0f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.progressLayer addAnimation:animation forKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = true;
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    
    [self removeObserver];
    
    [self.progressLayer removeAnimationForKey:kLLARingSpinnerAnimationKey];
    self.isAnimating = false;
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(-M_PI_4);
    CGFloat endAngle = (CGFloat)(3 * M_PI_2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [self.circleColor CGColor];
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

#pragma mark - 当前页面不在活动状态下，动画会停止
-(void)dealloc
{
    [self removeObserver];
}

-(void)addObserver
{
    //程序进入前台
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)becomeActive
{
//    NLog(@"\n\nloading\n加载状态：：：：%d\n加载动画：：：：%@\n\n",self.isAnimating,[self.progressLayer animationForKey:kLLARingSpinnerAnimationKey]);
    if (self.isAnimating && ![self.progressLayer animationForKey:kLLARingSpinnerAnimationKey]) {
        [self stopAnimating];
        [self startAnimating];
    }
}

//当前页面不显示在UIWindow的时候，会将动画CABasicAnimation给删除
//此时需要做处理，让动画动起来
- (void)willMoveToWindow:(UIWindow *)newWindow
{
//    NLog(@"\n\nloading\n所属Window：：：：%@\n加载状态：：：：%d\n加载动画：：：：%@\n\n",newWindow,self.isAnimating,[self.progressLayer animationForKey:kLLARingSpinnerAnimationKey]);
    if (newWindow && self.isAnimating && ![self.progressLayer animationForKey:kLLARingSpinnerAnimationKey]) {
        [self stopAnimating];
        [self startAnimating];
    }
}

@end
