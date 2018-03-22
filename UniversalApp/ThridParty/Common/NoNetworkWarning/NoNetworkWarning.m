//
//  NoNetworkWarning.m
//  PanGu
//
//  Created by jade on 2017/12/5.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import "NoNetworkWarning.h"

@implementation NoNetworkWarning

static NoNetworkWarning *_noNetworkWarning;

+ (NoNetworkWarning *)shareManager {
    static dispatch_once_t onceObj;
    dispatch_once(&onceObj, ^{
        _noNetworkWarning = [[self alloc] init];
    });
    return _noNetworkWarning;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, NAV_HEIGHT + 50, 300, 40);
        
        self.delegate = self;
        
        self.text = @"网络不给力，请检查您的网络设置";
        self.textColor = COLOR_WHITE;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithImage:ImageNamed(@"public_nonetwork")];
        leftImage.frame = CGRectMake(0, 0, 40, 40);
        leftImage.contentMode = UIViewContentModeCenter;
        
        self.leftView = leftImage;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:ImageNamed(@"trade_rightarrow")];
        rightImage.frame = CGRectMake(0, 0, 40, 40);
        rightImage.contentMode = UIViewContentModeCenter;
        
        self.rightView = rightImage;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSystemSetting)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapGes];
        
        self.backgroundColor = COLOR_RED;
        self.layer.cornerRadius = 20;
        self.layer.shadowColor = COLOR_RED.CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 5);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 4;
        
        self.centerX = kScreenWidth / 2;
         [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)openSystemSetting {
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
