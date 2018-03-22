//
//  UIView+Shadow.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Shadow)

- (void) makeInsetShadow;
- (void) makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha;
- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;

+(UIView*)tableviewHead:(float)radius Color:(UIColor *)color frame:(CGRect)frame;

@end
