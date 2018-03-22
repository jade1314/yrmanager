//
//  UIWaveView.m
//  PanGu
//  自定义动画 －－ 波浪
//  Created by jade on 16/6/24.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UIWaveView.h"

@interface UIWaveView()<UICollisionBehaviorDelegate>
{
    //浪宽
//    CGFloat waterWaveWidth;
    //偏移量
    CGFloat offsetX;
    CGFloat offsetXB;
    //计时器
    CADisplayLink *waveDisplaylink;
    //非根图层
    CAShapeLayer  *waveLayer;
    
    CAShapeLayer  *waveLayerTwo;
}


@end

@implementation UIWaveView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //默认数值
        self.backgroundColor = [UIColor colorWithRed:43/255.0 green:191/255.0 blue:53/255.0 alpha:1];
        self.layer.masksToBounds  = YES;
        _waterWaveHeight = frame.size.height / 2;
        _waterWaveWidth  = frame.size.width;
        _single = YES;
    }
    
    return self;
}
/**
 *  实时改变背景颜色
 */
-(void)setWaveColorT:(UIColor *)color1 andColorF:(UIColor *)color2{
    
    waveLayer.fillColor = color1.CGColor;
    waveLayerTwo.fillColor = color2.CGColor;

}
-(void) wave{
    
    //非根图层
    waveLayer = [CAShapeLayer layer];
    waveLayer.fillColor = self.colorF.CGColor;
    [self.layer addSublayer:waveLayer];
    
    waveLayerTwo = [CAShapeLayer layer];
    waveLayerTwo.fillColor = self.colorT.CGColor;
    [self.layer addSublayer:waveLayerTwo];
    
    //计时器
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
//计时事件
-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    offsetX += self.waveSpeed;
    
    offsetXB += (self.waveSpeed + +self.waveOffSetXSpeed);
    
    [self getgetCurrentWavePath];
    
    if (_single) {
        [self getgetCurrentWavePathTwo];
    }
    
}
//画路径
-(void)getgetCurrentWavePath{
    @try {
        UIBezierPath *p = [UIBezierPath bezierPath];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, 0, _waterWaveHeight);
        CGFloat y = 0.0f;
        for (float x = 0.0f; x <=  self.frame.size.width ; x++) {
            y = self.waveAmplitude * sinf((360/_waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + _waterWaveHeight;
            CGPathAddLineToPoint(path, nil, x, y);
        }
        
        CGPathAddLineToPoint(path, nil, self.frame.size.width, self.frame.size.height);
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
        CGPathCloseSubpath(path);
        
        p.CGPath = path;
        waveLayer.path = path;
        //记得释放
        CGPathRelease(path);
    } @catch (NSException *exception) {
        
    } 
}
//画路径
-(void)getgetCurrentWavePathTwo{
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, _waterWaveHeight + _waterWaveOffSetXHeight);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  self.frame.size.width ; x++) {
        y = (self.waveAmplitude + self.waveOffSetXAmplitude)* cosf((360/_waterWaveWidth) *(x * M_PI / 180) - offsetXB * M_PI / 180) + (_waterWaveHeight+_waterWaveOffSetXHeight);
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.frame.size.width, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    waveLayerTwo.path = path;
    //记得释放
    CGPathRelease(path);
    
}
//停止动画
-(void) stop{
    [waveDisplaylink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [waveDisplaylink invalidate];
    waveDisplaylink = nil;
}


@end
