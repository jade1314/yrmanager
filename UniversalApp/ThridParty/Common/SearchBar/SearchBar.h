//
//  OCSearchBar.h
//  TextField
//
//  Created by 王玉 on 16/5/16.
//  Copyright © 2016年 ORB-Jade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchBar;
@protocol SearchBarViewDelegate <NSObject>
@optional
- (BOOL)OCSearchBarShouldBeginEditing:(SearchBar *)searchBar;
- (void)OCSearchBarTextDidBeginEditing:(SearchBar *)searchBar;
- (BOOL)OCSearchBarShouldEndEditing:(SearchBar *)searchBar;
- (void)OCSearchBarTextDidEndEditing:(SearchBar *)searchBar;
- (void)OCSearchBar:(SearchBar *)searchBar
      textDidChange:(NSString *)searchText;
- (BOOL)OCSearchBar:(SearchBar *)searchBar
shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text;
//点击键盘搜索
- (void)OCSearchBarSearchButtonClicked:(SearchBar *)searchBar;
//点击搜索框中的搜索按钮开始搜索
- (void)OCRightSearchBtnClick:(UITapGestureRecognizer *)tap;
@end

@interface SearchBar : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UIImage *backViewImage;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *leftImageView;//左侧自定义图片
@property (nonatomic, strong) UIImage *leftImage;//左侧自定义图片

@property (nonatomic, strong) UIImageView *rightImageView;//右侧自定义图片
@property (nonatomic, strong) UIImage *rightImage;//左侧自定义图片

@property (nonatomic, copy  ) NSString *placeholder;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL isFirstResponder;
@property (nonatomic, weak) id <SearchBarViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;
- (void)setupLeftImageView:(UIImage *)leftImage rightImageView:(UIImage *)rightImage;

@end
