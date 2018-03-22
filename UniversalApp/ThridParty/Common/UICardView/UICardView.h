//
//  UICardView.h
//  PanGu
//  轮播资源循环利用  
//  Created by jade on 16/6/28.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  UICardViewDelegate <NSObject>

@optional

@required
//获得资源
-(NSArray *)getRealData;

@end

@interface UICardView : UIScrollView

//代理
@property(nonatomic,retain)id<UICardViewDelegate>delegateCard;

/**
 * 初始化方法
 *
 */
-(instancetype)initWithFrame:(CGRect)frame andContentCount:(NSInteger)count;

@end
