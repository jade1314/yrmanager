//
//  TradeErrorAlertView.h
//  PanGu
//
//  Created by jade on 16/8/23.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickTrueBlock)(void);
typedef void(^clickFalseBlock)(void);

@interface TradeErrorAlertView : UIView

@property (nonatomic, copy  ) clickTrueBlock clickTrueBlock;
@property (nonatomic, copy  ) clickFalseBlock clickFalseBlock;

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSMutableAttributedString * attributeTitle;

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UIButton *trueButton;
@property (nonatomic, strong) UIButton *falseButton;


- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock;
- (id)initAttributeTitle:(NSMutableAttributedString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock;
- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock clickFalseBlock:(clickFalseBlock)clickFalseBlock;
- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock clickFalseBlock:(clickFalseBlock)clickFalseBlock isTrade:(BOOL)isTrade;

@end
