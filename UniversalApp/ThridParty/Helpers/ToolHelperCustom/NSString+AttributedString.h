//
//  NSString+AttributedString.h
//  PanGu
//
//  Created by jade on 2016/11/24.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)


/**
 *  设置段落样式
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *
 *  @return 富文本
 */
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font;


/**
 *  计算富文本字体高度
 *
 *  @param paraStyle  字体样式
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(NSMutableParagraphStyle*)paraStyle withFont:(UIFont*)font withWidth:(CGFloat)width;

@end
