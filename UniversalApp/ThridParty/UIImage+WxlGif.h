//
//  UIImage+WxlGif.h
//  PanGu
//
//  Created by 张琦 on 2017/3/30.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WxlGif)

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

+ (NSArray *)imgArray:(NSData *)data;


@end
