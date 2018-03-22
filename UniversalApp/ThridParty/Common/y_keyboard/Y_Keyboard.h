//
//  Y_Keyboard.h
//  PanGu
//
//  Created by jade on 16/8/19.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shouldReturnBlock)(UIView *keyboard, NSString *text, UITextField *textField);
typedef void(^textChangeBlock)(UIView *keyboard, NSString *text, UITextField *textField);
typedef void(^textAssignmentBlock)(NSString *text, UITextField *textField);
typedef void(^textFieldShouldBeginBlock)(UIView *keyboard, UITextField *textField);
typedef void(^textFieldInputBlock)(UIView *keyboard, NSString *text, UITextField *textField);

@interface Y_Keyboard : UIView <UITextFieldDelegate>
{
    @private
    UIView *_26KeyBack;
    UIView *_numberBack;
    NSArray *_lowercaseArray;
    NSArray *_capitalArray;
}

// 在 TextField 切换是重写
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) textAssignmentBlock textAssignmentBlock;
@property (nonatomic, copy) shouldReturnBlock shouldReturnBlock;
@property (nonatomic, copy) textChangeBlock textChangeBlock;
@property (nonatomic, copy) textFieldShouldBeginBlock textFieldShouldBeginBlock;
@property (nonatomic, copy) textFieldInputBlock textFieldInputBlock;

@property (nonatomic, copy) void(^textFieldShouldBeginEditingBlock)(void);
@property (nonatomic, copy) void(^textFieldShouldClearBlock)(void);

/**
 *  @param shouldReturnBlock 点击确定
 *  @param packUpBlock       点击收起
 */
- (id)initWithFrame:(CGRect)frame textField:(UITextField *)textField shouldReturn:(shouldReturnBlock)shouldReturnBlock textChange:(textChangeBlock)textChangeBlock;

- (id)initWithFrame:(CGRect)frame textField:(UITextField *)textField andNumLimit:(NSInteger)limit shouldReturn:(shouldReturnBlock)shouldReturnBlock textChange:(textChangeBlock)textChangeBlock;

@end
