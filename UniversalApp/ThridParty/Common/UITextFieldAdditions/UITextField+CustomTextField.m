//
//  UITextField+CustomTextField.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UITextField+CustomTextField.h"

@implementation UITextField (CustomTextField)


/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,输入框的类型枚举类型,文字对齐方式枚举类型
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle TextAlignment:(NSTextAlignment)textAlignment
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.textAlignment = textAlignment;
    }
    return self;
}


/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,文字对齐方式枚举类型
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.textAlignment = textAlignment;
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,字体的颜色,字体的大小,输入框的类型枚举类型,文字对齐方式枚举类型
 */
- (id)initWithFrame:(CGRect)frame TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle TextAlignment:(NSTextAlignment)textAlignment
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.textAlignment = textAlignment;
        
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,输入框的类型枚举类型
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
    }
    return self;
}


/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,字体的颜色,字体的大小,输入框的类型枚举类型
 */
- (id)initWithFrame:(CGRect)frame TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,输入框的类型枚举类型,文字对齐方式枚举类型,设置代理
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle TextAlignment:(NSTextAlignment)textAlignment Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.textAlignment = textAlignment;
        self.delegate = delegate;
    }
    return self;
}


/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,文字对齐方式枚举类型,设置代理
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.textAlignment = textAlignment;
        self.delegate = delegate;
    }
    return self;
}


/**
 *自定义初始化方法依次需填入的属性为:frame,字体的颜色,字体的大小,输入框的类型枚举类型,文字对齐方式枚举类型,设置代理
 */
- (id)initWithFrame:(CGRect)frame TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle TextAlignment:(NSTextAlignment)textAlignment Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.textAlignment = textAlignment;
        self.delegate = delegate;
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,输入框的类型枚举类型,设置代理
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.delegate = delegate;
    }
    return self;
}


/**
 *自定义初始化方法依次需填入的属性为:frame,占位字符,字体的颜色,字体的大小,设置代理
 */
- (id)initWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder TextColor:(UIColor *)color Font:(UIFont *)font Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.placeholder = placeholder;
        self.textColor = color;
        self.font = font;
        self.delegate = delegate;
    }
    return self;
}

/**
 *自定义初始化方法依次需填入的属性为:frame,字体的颜色,字体的大小,输入框的类型枚举类型,设置代理
 */
- (id)initWithFrame:(CGRect)frame TextColor:(UIColor *)color Font:(UIFont *)font BorderStyle:(UITextBorderStyle)borderStyle Delegate:(id)delegate
{
    self = [self init];
    if (self) {
        self.frame = frame;
        self.textColor = color;
        self.font = font;
        self.borderStyle = borderStyle;
        self.delegate = delegate;
    }
    return self;
}

@end
