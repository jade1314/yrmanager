//
//  UITextField+ExtentRange.h
//  PanGu
//
//  Created by jade on 2017/10/24.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;

@end
