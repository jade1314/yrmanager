//
//  AlertView.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PubAlertViewDelegate <NSObject>

- (void)touchAlertView:(UIView *)alertView MethodWithButton:(UIButton *)button;

@end

@interface AlertView : UIView

//背景View 遮挡业务页面,不让点击业务页面
@property (nonatomic, strong)UIView * backGroundView;
//标题label
@property (nonatomic, strong)UILabel * titleLabel;
//提示信息label
@property (nonatomic, strong)UILabel * messageLabel;
//左边第一个button(通常用于取消按钮)
@property (nonatomic, strong)UIButton * cancleButton;
//其他的按钮,位于cancleButton右边
@property (nonatomic, strong)UIButton * otherbutton1;
@property (nonatomic, assign)id<PubAlertViewDelegate> delegate;

//图片
@property (nonatomic,strong) UIImageView * img;
//初始化alertView
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle;

- (id)initWithTitle:(NSString *)title image:(UIImage *)img rect:(CGRect)rect delegate:(id)delegate;
//显示alertView
- (BOOL)alertviewShow;

@end
