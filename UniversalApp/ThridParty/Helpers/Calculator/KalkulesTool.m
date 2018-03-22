//
//  KalkulesTool.m
//  PanGu
//
//  Created by jade on 2017/9/12.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import "KalkulesTool.h"

@implementation NSString (KalkulesTool)

@dynamic add;
@dynamic sub;
@dynamic mul;
@dynamic div;

- (NSString *(^)(NSString *))add {
    
    return ^(NSString *addValue) {
        return decimalNumberCalculateWithString(self, addValue, 1);
    };
}

- (NSString *(^)(NSString *))sub {
    
    return ^(NSString *subValue) {
        return decimalNumberCalculateWithString(self, subValue, 2);
    };
}

- (NSString *(^)(NSString *))mul {
    return ^(NSString *mul) {
        return decimalNumberCalculateWithString(self, mul, 3);
    };
}

- (NSString *(^)(NSString *))div {
    return ^(NSString *div) {
        return decimalNumberCalculateWithString(self, div, 4);
    };
}

/**
 calType = 1(加)
 calType = 2(减)
 calType = 3(乘)
 calType = 4(除)
 */
NSString *decimalNumberCalculateWithString(NSString *value, NSString *otherValue, int calType)
{
    if (value.length == 0)    value = @"0.00";
    
    if (otherValue.length == 0)  otherValue = @"0.00";
    
    NSDecimalNumber *number   = [NSDecimalNumber decimalNumberWithString:value];
    
    NSDecimalNumber *otherNumber = [NSDecimalNumber decimalNumberWithString:otherValue];
    
    if ([[NSDecimalNumber notANumber] isEqualToNumber:number] ||
        [[NSDecimalNumber notANumber] isEqualToNumber:otherNumber]) {
        return @"0.00";
    }
    
    NSDecimalNumber *product;
    if (calType == 1) {
        product = [number decimalNumberByAdding:otherNumber];
    }else if (calType == 2) {
        product = [number decimalNumberBySubtracting:otherNumber];
    }else if (calType == 3) {
        product = [number decimalNumberByMultiplyingBy:otherNumber];
    }else if (calType == 4) {
        product = [number decimalNumberByDividingBy:otherNumber];
    }
    
    return [product stringValue];
}

@end
