//
//  UIImage+Alpha.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize color:(UIColor *)color;
-(UIImage *)imageWithShadow:(UIColor*)_shadowColor
                 shadowSize:(CGSize)_shadowSize
                       blur:(CGFloat)_blur;

- (UIImage *)maskWithColor:(UIColor *)color;

- (UIImage *)maskWithColor:(UIColor *)color
               shadowColor:(UIColor *)shadowColor
              shadowOffset:(CGSize)shadowOffset
                shadowBlur:(CGFloat)shadowBlur;

@end
