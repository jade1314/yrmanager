//
//  NSArray+set.m
//  PanGu
//
//  Created by jade on 16/7/13.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "NSArray+set.h"


@implementation NSArray (set)

-(id)objectNAtIndex:(NSUInteger)index{
    
    id object;
    
    if (index < self.count) {
        
        object = [self objectAtIndex:index];
        
        if ([object isKindOfClass:[NSNull class]]) {
            NSLog(@"服务器又返回错误字段了");
        }
        
    }else{
        
        NSLog(@"数组越界，看仔细点");
        return @"";
        
    }
    
    return object;
}

@end
