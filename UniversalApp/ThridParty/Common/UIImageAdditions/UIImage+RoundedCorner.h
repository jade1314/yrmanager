//
//  UIImage+RoundedCorner.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedCorner)

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

- (UIImage *) normalize;

- (UIImage*)imageWithRadius:(float) radius
                      width:(float)width
                     height:(float)height;

@end
