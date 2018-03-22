//
//  DecimalNumber.m
//  PanGu
//
//  Created by jade on 16/12/22.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "DecimalNumber.h"

@implementation DecimalNumber

//保留2位小数  不四舍五入
+ (NSString *)decimalTwoNumber:(NSString *)str {
    NSString *numStr = @"";
    
    NSRange range;
    range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger dotAfterLength = (str.length - (range.location + 1));
        if (dotAfterLength == 1) {
            numStr = [NSString stringWithFormat:@"%@0",str];
        } else if (dotAfterLength == 2) {
            numStr = str;
        } else if (dotAfterLength > 3){
            numStr = [str substringToIndex:(range.location + 2) + 1];
        }
    }else{
        numStr = [NSString stringWithFormat:@"%@.00",str];
    }
    
    return numStr;
}


//保留3位小数  不四舍五入
+ (NSString *)decimalThreeNumber:(NSString *)str {
    NSString *numStr = @"";
    
    NSRange range;
    range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger dotAfterLength = (str.length - (range.location + 1));
        if (dotAfterLength == 1) {
            numStr = [NSString stringWithFormat:@"%@00",str];
        } else if (dotAfterLength == 2) {
            numStr = [NSString stringWithFormat:@"%@0",str];
        } else if (dotAfterLength == 3) {
            numStr = str;
        } else if (dotAfterLength > 3){
            numStr = [str substringToIndex:(range.location + 3) + 1];
        }
    }else{
        numStr = [NSString stringWithFormat:@"%@.000",str];
    }
    
    return numStr;
}

//保留4位小数  不四舍五入
+ (NSString *)decimalFourthNumber:(NSString *)str {
    NSString *numStr = @"";
    
    NSRange range;
    range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger dotAfterLength = (str.length - (range.location + 1));
        if (dotAfterLength == 1) {
            numStr = [NSString stringWithFormat:@"%@000",str];
        } else if (dotAfterLength == 2) {
            numStr = [NSString stringWithFormat:@"%@00",str];
        } else if (dotAfterLength == 3) {
            numStr = [NSString stringWithFormat:@"%@0",str];
        }else if (dotAfterLength == 4) {
            numStr = str;
        } else if (dotAfterLength > 4){
            numStr = [str substringToIndex:(range.location + 4) + 1];
        }
    }else{
        numStr = [NSString stringWithFormat:@"%@.0000",str];
    }
    
    return numStr;
}

//保留3位小数  四舍五入
+ (NSString *)decimalThreeNumberRound:(NSString *)str {
    NSString *numStr = @"";
    
    NSRange range;
    range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger dotAfterLength = (str.length - (range.location + 1));
        if (dotAfterLength == 1) {
            numStr = [NSString stringWithFormat:@"%@00",str];
        } else if (dotAfterLength == 2) {
            numStr = [NSString stringWithFormat:@"%@0",str];
        } else if (dotAfterLength == 3) {
            numStr = str;
        } else if (dotAfterLength > 3){
            numStr = [NSString stringWithFormat:@"%.3f",[str floatValue]];
        }
    }else{
        numStr = [NSString stringWithFormat:@"%@.000",str];
    }
    
    return numStr;
}

//保留4位小数  四舍五入
+ (NSString *)decimalFourthNumberRound:(NSString *)str {
    NSString *numStr;
    
    NSRange range;
    range = [str rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger dotAfterLength = (str.length - (range.location + 1));
        if (dotAfterLength == 1) {
            numStr = [NSString stringWithFormat:@"%@000",str];
        } else if (dotAfterLength == 2) {
            numStr = [NSString stringWithFormat:@"%@00",str];
        } else if (dotAfterLength == 3) {
            numStr = [NSString stringWithFormat:@"%@0",str];
        }else if (dotAfterLength == 4) {
            numStr = str;
        } else if (dotAfterLength > 4){
            numStr = [NSString stringWithFormat:@"%.4f",[str floatValue]];
        }
    }else{
        numStr = [NSString stringWithFormat:@"%@.0000",str];
    }
    
    return numStr;
}



@end
