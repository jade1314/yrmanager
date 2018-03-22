//
//  UIView+ReFreshView.m
//  PanGu
//
//  Created by jade on 2017/1/20.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import "UIView+ReFreshView.h"

@implementation UIView (ReFreshView)

+(void)creatReFreshView:(void(^)(id action))block forView:(UIView *)superView andYDistance:(CGFloat)distance{

    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth *2/3, kScreenHeight/4)];
    
    UIImageView *imav = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tipView.width, tipView.height - 20)];
    imav.image = [UIImage imageNamed:@"newskong"];
    imav.contentMode = UIViewContentModeScaleAspectFit;
    imav.centerX = tipView.centerX;
    [tipView addSubview:imav];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imav.width, 20)];
    la.text = @"点击重新加载";
    la.textAlignment = NSTextAlignmentCenter;
    la.top = imav.bottom + 5;
    la.textColor = COLOR_LIGHTGRAY;
    la.font = [UIFont systemFontOfSize:14];
    [tipView addSubview:la];
    
    [superView addSubview:tipView];
    tipView.center = CGPointMake(superView.centerX, distance);
    tipView.hidden = YES;
    
    if (block) {
        block(tipView);
    }
}


@end
