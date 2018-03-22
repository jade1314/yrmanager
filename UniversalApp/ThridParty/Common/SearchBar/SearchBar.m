//
//  OCSearchBar.m
//  TextField
//
//  Created by 王玉 on 16/5/16.
//  Copyright © 2016年 ORB-Jade. All rights reserved.
//


#import "SearchBar.h"
#import "Miscellaneous.h"
#define kSingleLine_Width 1/[UIScreen mainScreen].bounds.size.width

@interface SearchBar ()
@property (nonatomic, strong) UIImageView *backGroundView;


@property (nonatomic, assign) BOOL isVisible;

@end
@implementation SearchBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = COLOR_WHITE;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width - 30, self.height)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:self.textField];
    [self.textField addTarget:self action:@selector(OCSearchBarDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self setupDefaultBackGroundView];
}
- (void)setupDefaultBackGroundView {
    
    // 使用颜色创建UIImage
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.backGroundView setImage:colorImage];
    
}

-(void)setupLeftImageView:(UIImage *)leftImage rightImageView:(UIImage *)rightImage{
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    leftImageView.contentMode = UIViewContentModeCenter;
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:rightImage];
    rightImageView.contentMode = UIViewContentModeCenter;
    rightImageView.userInteractionEnabled = YES;
    self.leftImageView = leftImageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightSearchBtnClick:)];
    [rightImageView addGestureRecognizer:tap];
    
    
}
- (void)setFont:(UIFont *)font {
    self.textField.font = font;
    
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self.textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
}
- (void)setTextColor:(UIColor *)textColor {
    [self.textField setTextColor:textColor];
    
}
- (void)setText:(NSString *)text {
    self.textField.text = text;
}
- (NSString *)text {
    return self.textField.text;
}
- (void)setBackViewImage:(UIImage *)backViewImage {
    [self.backGroundView setImage:backViewImage];
    
}
- (void)setLeftImageView:(UIImageView *)leftImageView {
    if (self.leftImageView.superview) {
        [self.leftImageView removeFromSuperview];
    }
    [self addSubview:leftImageView];
    CGFloat leftMargin;
    if (self.width == kScreenWidth - 70) {
        leftMargin = 20;
    }else{
        leftMargin= (self.height - leftImageView.height)/2;
    }
    
    leftImageView.left = leftMargin;
    leftImageView.top = (self.height - leftImageView.height)/2.0;
    
    CGRect rect = self.textField.bounds;
    rect.origin.x = leftImageView.width+(self.height - leftImageView.height) + 10;
    rect.size.width = self.width - leftImageView.frame.origin.x - leftImageView.frame.size.width-5;
    [self.textField setFrame:rect];
    
}
- (void)setRightImageView:(UIImageView *)rightImageView {
    if (self.rightImageView.superview) {
        [self.rightImageView removeFromSuperview];
    }
    [self addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(0));
        make.bottom.equalTo(@(0));
    }];
    CGRect rect = self.textField.frame;
    rect.size.width = rect.size.width - rightImageView.frame.size.width-5;
    [self.textField setFrame:rect];
    
}
- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}
- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}
#pragma mark - OCTextFieldDelegate
- (void)rightSearchBtnClick:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCRightSearchBtnClick:)]) {
        [self.delegate OCRightSearchBtnClick:tap];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBarShouldBeginEditing:)] ) {
        return [self.delegate OCSearchBarShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.isFirstResponder = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBarTextDidBeginEditing:)]) {
        [self.delegate OCSearchBarTextDidBeginEditing:self];
    }
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBarShouldEndEditing:)]) {
        return [self.delegate OCSearchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBarTextDidEndEditing:)]) {
        [self.delegate OCSearchBarTextDidEndEditing:self];
    }
}
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate OCSearchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBarSearchButtonClicked:)]) {
        [self.delegate OCSearchBarSearchButtonClicked:self];
    }
    return YES;
}
- (void)OCSearchBarDidChange:(UITextField *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(OCSearchBar:textDidChange:)]) {
        [self.delegate OCSearchBar:self textDidChange:sender.text];
    }
}
@end
