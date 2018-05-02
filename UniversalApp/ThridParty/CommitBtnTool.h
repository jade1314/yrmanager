//
//  CommitBtnTool.h
//  PanGu
//
//  Created by 王玉 on 2016/11/11.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitBtnTool : UIButton
- (instancetype)initWithFrame:(CGRect)frame completion:(void(^)(UIButton *btn))completion title:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame completion:(void(^)(UIButton *btn))completion title:(NSString *)title corner:(CGFloat)radio;
@end
