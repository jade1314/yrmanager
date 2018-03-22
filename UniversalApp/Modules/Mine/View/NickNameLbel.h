//
//  NickNameLbel.h
//  MiAiApp
//
//  Created by JadeM on 2017/6/13.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 昵称Label 包含 昵称 性别 年龄 等级
 */
@interface NickNameLbel : UIView


- (void)setNickName:(NSString *)nickName sex:(UserGender)sex age:(NSInteger)age level:(NSInteger)level;

@end
