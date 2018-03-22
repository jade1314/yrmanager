//
//  UIImage+UIRoundedImage.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIRoundedImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
