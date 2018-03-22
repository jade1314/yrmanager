//
//  CustomTextView.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView

@property (nonatomic, retain) NSString * placeHolder;//占位字符内容
@property (nonatomic, retain) UILabel * placeLabel;//占位的label
@property (nonatomic, assign) BOOL adaptiveHeight;//是否自适应高度YES自适应NO不自适应.默认是NO
@property (nonatomic, assign) NSInteger maxNumberOfLine;//最大可以输入多少行
@property (nonatomic, retain) UILabel * numberOfText;//文本字数显示
@property (nonatomic, assign) NSInteger maxNumberOfWords;//输入的最大字数

//frame,字体大小,字体颜色,背景颜色,占位字符,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor BackgroundColor:(UIColor *)backgroundcolor PlaceHolder:(NSString *)placeHolder Delegate:(id)delegate;


//frame,字体大小,字体颜色,背景颜色,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor BackgroundColor:(UIColor *)backgroundcolor Delegate:(id)delegate;


//frame,字体大小,字体颜色,占位字符,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)color PlaceHolder:(NSString *)placeHolder Delegate:(id)delegate;


//frame,字体大小,字体颜色,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)color Delegate:(id)delegate;

@end
