//
//  WarningAlertView.h
//  PanGu
//
//  Created by jade on 2017/6/26.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBlock)(void);
typedef void(^RightBlock)(void);

@interface WarningAlertView : UIView

@property (nonatomic, copy) LeftBlock leftBlock;

@property (nonatomic, copy) RightBlock rightBlock;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSString *leftText;

@property (nonatomic, copy) NSString *rightText;




- (id)initWithTitle:(NSString *)title clickLeftBlock:(LeftBlock)leftBlock clickRightBlock:(RightBlock)rightBlock;

@end
