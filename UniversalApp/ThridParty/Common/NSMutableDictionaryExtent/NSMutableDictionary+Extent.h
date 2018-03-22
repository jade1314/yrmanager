//
//  NSMutableDictionary+Extent.h
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSMutableDictionary (Extent)

+ (void)extent;
- (void)setDictionaryObject:(id)anObject forKey:(id)key;
- (id)objectNotNULLForKey:(id)key;
//void setDictionaryObject(id self,IMP cmd,id object, id key);

@end

@interface NSUserDefaults (extent)
- (void)setUserDefaultObject:(id)anObject forKey:(id)key;
- (id)objectNotNULLForKey:(id)key;
@end

@interface NSDictionary (extent)
- (id)objectNotNULLForKey:(id)key;
@end
