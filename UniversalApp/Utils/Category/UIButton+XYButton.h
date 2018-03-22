//
//  UIButton+XYButton.h
//  MiAiApp
//
//  Created by JadeM on 2017/6/1.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XYButton)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

@end
