//
//  MaskView.m
//  粒子效果
//
//  Created by jade on 16/4/27.
//  Copyright © 2016年 Qi Jiyu. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.image = [UIImage imageNamed:@"moreconent"];
        
        // 创建CAGradientLayer
        [self createCAGradientLayer];
    }
    return self;
}

- (void)createCAGradientLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame            = CGRectMake(0, 0, self.width * 3, self.height);
    gradientLayer.colors           = @[(__bridge id)[UIColor blackColor].CGColor,
                                       (__bridge id)[UIColor blackColor].CGColor,
                                       (__bridge id)[UIColor colorWithWhite:0.000 alpha:0.204].CGColor,
                                       (__bridge id)[UIColor blackColor].CGColor,
                                       (__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations        = @[@(0.25), @(0.345), @(0.5), @(0.545), @(0.75)];
    gradientLayer.startPoint       = CGPointMake(0, 0);
    gradientLayer.endPoint         = CGPointMake(1, 0.05);
    
    // 创建容器View  -->  用于加载创建出的CAGradientLayer
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width * 3, self.height)];
    [containerView.layer addSublayer:gradientLayer];
    
    self.maskView = containerView;
    self.maskView.x = -self.width - self.width;
    
    // 添加动画
    [self startAnimation];
}

- (void)startAnimation {
    
    [UIView animateWithDuration:1.5 animations:^{
        self.maskView.x = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.maskView.x = -self.width - self.width;
            [self startAnimation];
        }
    }];
}

@end
