//
//  UINavigationItem+CustomItem.h
//  PanGu
//
//  Created by jade on 16/6/3.
//  Copyright © 2016年 jade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBarItem.h"

@interface UINavigationItem (CustomItem)

- (CustomBarItem *)setItemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type;
- (CustomBarItem *)setItemWithImage:(NSString *)imageName size:(CGSize)size itemType:(ItemType)type;
- (CustomBarItem *)setItemWithCustomView:(UIView *)customView itemType:(ItemType)type;

@end
