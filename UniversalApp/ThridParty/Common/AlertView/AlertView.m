//
//  AlertView.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
{
    BOOL isShow;
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        isShow = NO;
        [self initViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle];
    }
    return self;
}

//初始化alertView页面
- (BOOL)initViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:( NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle
{
    BOOL bRet = NO;
    @try {
        UIView * line1View = nil;
        UIView * line2View = nil;
        CGFloat width = kScreenWidth - 40;
        CGFloat height = ((kScreenHeight - (kScreenWidth - 40) * 2/3)) / 2.0;
        
        self.backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backGroundView.backgroundColor = [UIColor blackColor];
        self.backGroundView.alpha = 0.3;
        
        self.frame = CGRectMake(20, height , width, (kScreenWidth - 40) * 2/3);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.userInteractionEnabled = YES;
        
        line1View = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 50.5, width, 0.5)];
        line1View.backgroundColor = [UIColor colorWithRed:188.0 / 255.0 green:186.0 / 255.0 blue:193.0 / 255.0 alpha:1.0];
        [self addSubview:line1View];
        
        line2View = [[UIView alloc] initWithFrame:CGRectMake(width / 2 - 0.25, self.height - 50, 0.5, 50)];
        line2View.backgroundColor = [UIColor colorWithRed:188.0 / 255.0 green:186.0 / 255.0 blue:193.0 / 255.0 alpha:1.0];
        [self addSubview:line2View];
        
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleButton.frame = CGRectMake(0, self.height - 50, width / 2, 50);
        [self.cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        self.cancleButton.tag = 1000;
        [self.cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancleButton addTarget:self action:@selector(touchMethod:) forControlEvents:UIControlEventTouchUpInside];
        self.cancleButton.enabled = YES;
        
        self.otherbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.otherbutton1.frame = CGRectMake(self.cancleButton.right, self.height - 50, width / 2, 50);
        [self.otherbutton1 setTitle:otherButtonTitle forState:UIControlStateNormal];
        self.otherbutton1.tag = 1001;
        [self.otherbutton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.otherbutton1 addTarget:self action:@selector(touchMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 50)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.bottom, width -20, (kScreenWidth - 40) * 2/3 - 140)];
        self.messageLabel.text = message;
        self.messageLabel.numberOfLines = 0;//可以换行
        self.messageLabel.font = [UIFont  systemFontOfSize:15.0];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        UILabel * label = [[UILabel alloc] initWithFrame:self.messageLabel.bounds];
        label.text = self.messageLabel.text;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        self.frame = CGRectMake(self.left, self.top, self.width, 130 + label.height);
        self.messageLabel.frame = CGRectMake(self.messageLabel.left, self.messageLabel.top, self.messageLabel.width, label.height);
        self.cancleButton.frame = CGRectMake(0, self.height - 50, width / 2, 50);
        self.otherbutton1.frame = CGRectMake(self.cancleButton.right, self.height - 50, width / 2, 50);
        line1View.frame = CGRectMake(0, self.height - 50.5, width, 0.5);
        line2View.frame = CGRectMake(width / 2 - 0.25, self.height - 50, 0.5, 50);
        [self addSubview:self.cancleButton];
        [self addSubview:self.otherbutton1];
        self.delegate = delegate;
        
        
        bRet = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"alertView初始化失败");
        [ToolHelper bmsLog:@"alertView初始化失败"];
    }
    @finally {
        return bRet;
    }
}
- (id)initWithTitle:(NSString *)title image:(UIImage *)image rect:(CGRect)rect delegate:(id)delegate{
    
    self = [super init];
    if (self) {
        isShow = NO;
        self.backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backGroundView.backgroundColor = [UIColor blackColor];
        self.backGroundView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMethod:)];
        [self.backGroundView addGestureRecognizer:tap];
        self.frame =rect;
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height * 0.6, rect.size.width, 15)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        self.delegate = delegate;
//        self.img = [UIImageView alloc]initWithFrame:cgrec
        self.img = [[UIImageView alloc]initWithImage:image];
        _img.frame = CGRectMake((rect.size.width - image.size.width)/2, rect.size.height * 0.4,image.size.width, image.size.height);
        [self addSubview:_img];
    }
    return self;
    
}
//显示alertView
- (BOOL)alertviewShow
{
    BOOL bRet = NO;
    @try {
        if (isShow == NO) {
            [[[UIApplication  sharedApplication].delegate window].rootViewController.view addSubview:self.backGroundView];
            [[[UIApplication  sharedApplication].delegate window].rootViewController.view addSubview:self];
            isShow = YES;
        }
        
        
        bRet =YES;
    }
    @catch (NSException *exception) {
        NSLog(@"alertView显示失败");
        [ToolHelper bmsLog:@"alertView显示失败"];
    }
    @finally {
        return bRet;
    }
}

- (void)touchMethod:(UIButton *)button
{
    if (isShow == YES) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchAlertView:MethodWithButton:)]) {
            [self.delegate touchAlertView:self MethodWithButton:button];
        }
        [self.backGroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }
    
}
@end
