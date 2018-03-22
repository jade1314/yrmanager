//
//  UICarouselView.h
//  PanGu
//  轮播图控件
//  Created by jade on 16/6/27.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  UICarouselViewDelegate <NSObject>
@optional

//点击内容响应方法
-(void)UICarouselViewDidClicked:(NSUInteger)index;

@end

@interface UICarouselView : UIView<UIScrollViewDelegate>
//代理
@property(nonatomic,retain)id<UICarouselViewDelegate> delegate;
//初始化
-(id)initWithFrameRect:(CGRect)rect withData:(NSArray *)dataArr;
@end
