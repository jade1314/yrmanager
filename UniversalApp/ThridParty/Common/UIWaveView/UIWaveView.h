//
//  UIWaveView.h
//  PanGu
//  自定义动画 －－ 波浪
//  Created by jade on 16/6/24.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWaveView : UIView

/**
 *  浪高
 */
@property (nonatomic,assign) CGFloat waterWaveHeight;
/**
 *  浪高偏差
 */
@property (nonatomic,assign) CGFloat waterWaveOffSetXHeight;
/**
 *  几层动画  默认是两层
 */
@property (nonatomic,assign)BOOL single;

/**
 *  颜色
 */
@property (nonatomic,strong)UIColor *colorF;
/**
 *  颜色
 */
@property (nonatomic,strong)UIColor *colorT;

/**
 *  波浪的快慢
 */
@property (nonatomic,assign)CGFloat waveSpeed;
/**
 *  波浪的快慢偏差
 */
@property (nonatomic,assign)CGFloat waveOffSetXSpeed;

/**
 *  波浪的震荡幅度
 */
@property (nonatomic,assign)CGFloat waveAmplitude;
/**
 *  波浪的震荡幅度偏差
 */
@property (nonatomic,assign)CGFloat waveOffSetXAmplitude;



@property (nonatomic,assign)CGFloat waterWaveWidth;;

/**
 *  开始
 */
-(void) wave;

/**
 *  停止
 */
-(void) stop;
/**
 *  实时改变背景颜色
 */
-(void)setWaveColorT:(UIColor *)color1 andColorF:(UIColor *)color2;


@end
