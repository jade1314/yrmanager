//
//  UIPerspectiveView_Cell.h
//  PanGu
//  轮播图展示界面
//  Created by jade on 16/7/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"



@protocol  UIPerspectiveView_CellDelegate <NSObject>

@optional
//手势
-(void)handleTapAction;

-(void)handleSwipeUpAction;

-(void)handleSwipeDownAction;

//滑动距离
-(void)handlePointDistance:(CGFloat)dictance;

@required

@end

@interface UIPerspectiveView_Cell : UIView
//代理
@property(nonatomic,retain)id<UIPerspectiveView_CellDelegate>delegate;

@property(nonatomic,strong)UILabel *label;




@end
