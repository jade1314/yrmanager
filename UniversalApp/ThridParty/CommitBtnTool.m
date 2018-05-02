//
//  CommitBtnTool.m
//  PanGu
//
//  Created by 王玉 on 2016/11/11.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "CommitBtnTool.h"

@interface CommitBtnTool ()
@property (nonatomic,copy) void(^block)(UIButton *btn);

@end

@implementation CommitBtnTool
- (instancetype)initWithFrame:(CGRect)frame completion:(void(^)(UIButton *btn))completion title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _block = completion;
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage getImageWithColor:COLOR_LIGHTGRAY] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage getImageWithColor:COLOR_YELLOW] forState:UIControlStateNormal];
        self.selected = YES;
        self.userInteractionEnabled = NO;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)btnClicked:(UIButton *)sender{
    _block(self);
}

- (instancetype)initWithFrame:(CGRect)frame completion:(void(^)(UIButton *btn))completion title:(NSString *)title corner:(CGFloat)radio
{
    self = [super initWithFrame:frame];
    if (self) {
        _block = completion;
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage getImageWithColor:COLOR_LIGHTGRAY] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage getImageWithColor:COLOR_YELLOW] forState:UIControlStateNormal];
        self.selected = YES;
        self.userInteractionEnabled = NO;
        self.layer.cornerRadius = radio;
        self.layer.masksToBounds = YES;
        [self setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
@end
