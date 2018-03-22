//
//  UIActionSheet+Blocks.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIActionSheetBlock) (UIActionSheet *actionSheet);
typedef void (^UIActionSheetCompletionBlock) (UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (Blocks)

+ (void)showFromTabBar:(UITabBar *)tabBar
             withTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
              tapBlock:(UIActionSheetCompletionBlock)tapBlock;

+ (void)showFromToolbar:(UIToolbar *)toolbar
              withTitle:(NSString *)title
      cancelButtonTitle:(NSString *)cancelButtonTitle
 destructiveButtonTitle:(NSString *)destructiveButtonTitle
      otherButtonTitles:(NSArray *)otherButtonTitles
               tapBlock:(UIActionSheetCompletionBlock)tapBlock;

+ (id)showInView:(UIView *)view
       withTitle:(NSString *)title
cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
otherButtonTitles:(NSArray *)otherButtonTitles
        tapBlock:(UIActionSheetCompletionBlock)tapBlock;

+ (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                     animated:(BOOL)animated
                    withTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIActionSheetCompletionBlock)tapBlock;

+ (void)showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated
           withTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
   otherButtonTitles:(NSArray *)otherButtonTitles
            tapBlock:(UIActionSheetCompletionBlock)tapBlock;

@property (copy, nonatomic) UIActionSheetCompletionBlock tapBlock;
@property (copy, nonatomic) UIActionSheetCompletionBlock willDismissBlock;
@property (copy, nonatomic) UIActionSheetCompletionBlock didDismissBlock;

@property (copy, nonatomic) UIActionSheetBlock willPresentBlock;
@property (copy, nonatomic) UIActionSheetBlock didPresentBlock;
@property (copy, nonatomic) UIActionSheetBlock cancelBlock;

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
