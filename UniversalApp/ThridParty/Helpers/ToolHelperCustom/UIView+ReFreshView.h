//
//  UIView+ReFreshView.h
//  PanGu
//
//  Created by jade on 2017/1/20.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ReFreshView)

+(void)creatReFreshView:(void(^)(id action))block forView:(UIView *)superView andYDistance:(CGFloat)distance;

@end
