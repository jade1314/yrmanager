//
//  UIPerspectiveView.h
//  PanGu
//  悬浮循环轮播图
//  Created by jade on 16/7/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  UIPerspectiveViewDelegate <NSObject>



@required
@optional
//获得资源
-(NSArray *)getRealPerspectiveData;

@end

@interface UIPerspectiveView : UIView

//真实数据源
@property(nonatomic,strong)NSArray *realPerspectiveDataArr;

//代理
@property(nonatomic,retain)id<UIPerspectiveViewDelegate>delegate;

@end
