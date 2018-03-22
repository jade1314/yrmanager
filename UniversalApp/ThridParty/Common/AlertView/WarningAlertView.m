//
//  WarningAlertView.m
//  PanGu
//
//  Created by jade on 2017/6/26.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import "WarningAlertView.h"

@implementation WarningAlertView

- (id)initWithTitle:(NSString *)title clickLeftBlock:(LeftBlock)leftBlock clickRightBlock:(RightBlock)rightBlock {
    if (self = [super init]) {
        _title = title;
        _rect = [_title boundingRectWithSize:CGSizeMake(kScreenWidth - 70 - 52, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        self.frame = CGRectMake(0, 0, kScreenWidth - 70, _rect.size.height + 45 + 91 + (_rect.size.height / 12 * 6) - 6);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        [self customView];
        _leftBlock = leftBlock;
        _rightBlock = rightBlock;
    }
    return self;
}

- (void)customView {
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.width, 14)];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"提示";
    _tipLabel.font = [UIFont boldSystemFontOfSize:14];
    _tipLabel.textColor = COLOR_DARKGREY;
    [self addSubview:_tipLabel];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, _tipLabel.bottom + 11 - 6, self.width - 52, _rect.size.height + (_rect.size.height/12 * 6) - 6)];
    _contentLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
//    paraStyle01.alignment = NSTextAlignmentJustified;  //最后一行自然对齐
//    CGFloat emptylen = 12 * 2;
//    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 6.0f;//行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_title attributes:@{NSParagraphStyleAttributeName:paraStyle01,NSForegroundColorAttributeName:COLOR_DARKGREY,NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _contentLabel.attributedText = attrText;
    [self addSubview:_contentLabel];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentLabel.bottom + 20, self.width, KSINGLELINE_WIDTH)];
    lineView.backgroundColor = COLOR_LINE;
    [self addSubview:lineView];
    CGFloat buttonSpace = 25;
    CGFloat buttonWidth = (self.width - buttonSpace - 26 * 2) / 2;
    
    _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(26, lineView.bottom + (self.height - lineView.bottom - 30) / 2, buttonWidth, 30)];
    _confirmButton.backgroundColor = COLOR_BACK;
    _confirmButton.layer.cornerRadius = 2;
//    [_confirmButton setTitle:@"以后再说" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(_confirmButton.right + 25, lineView.bottom + (self.height - lineView.bottom - 30) / 2, buttonWidth, 30)];
    _cancelButton.backgroundColor = COLOR_BLUE;
    _cancelButton.layer.cornerRadius = 2;
//    [_cancelButton setTitle:@"现在评测" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
}

- (void)setLeftText:(NSString *)leftText {
    _leftText = leftText;
    [_confirmButton setTitle:_leftText forState:UIControlStateNormal];
}

- (void)setRightText:(NSString *)rightText {
    _rightText = rightText;
    [_cancelButton setTitle:_rightText forState:UIControlStateNormal];
}

- (void)clickLeftButton:(UIButton *)sender {
    if (_leftBlock) {
        _leftBlock();
    }
}

- (void)clickRightButton:(UIButton *)sender {
    if (_rightBlock) {
        _rightBlock();
    }
}

@end
