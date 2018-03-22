//
//  CustomBarItem.h
//  PanGu
//  自定义导航栏按钮
//  Created by jade on 16/6/3.
//  Copyright © 2016年 jade. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    left,//左边
    center,//居中部分
    right//右边部分
    
}ItemType;

@interface CustomBarItem : NSObject

//按钮
@property (nonatomic, strong) UIButton *contentBarItem;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) ItemType itemType;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) BOOL isCustomView;


+ (CustomBarItem *)itemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type;
+ (CustomBarItem *)itemWithImage:(NSString *)imageName size:(CGSize)size type:(ItemType)type;
+ (CustomBarItem *)itemWithCustomeView:(UIView *)customView type:(ItemType)type;
//添加按钮
- (void)setItemWithNavigationItem:(UINavigationItem *)navigationItem itemType:(ItemType)type;
//添加事件
- (void)addTarget:(id)target selector:(SEL)selector event:(UIControlEvents)event;
/**
 *设置item偏移量
 *@param offSet 正值向左偏，负值向右偏
 */
- (void)setOffset:(CGFloat)offSet;

@end
