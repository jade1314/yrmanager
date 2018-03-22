//
//  UIImage+ImageWithColor.h
//  PanGu
//
//  Created by jade on 16/7/1.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (UIImage *)getImageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage*)convertViewToImage:(UIView*)v;

@end
