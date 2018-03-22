//
//  NSMutableDictionary+Extent.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "NSMutableDictionary+Extent.h"

@implementation NSMutableDictionary (Extent)

+ (void)extent
{
    Class c = [NSMutableDictionary class];
    SEL origSEL = @selector(setObject:forKey:);
    SEL overrideSEL = @selector(setDictionaryObject:forKey:);
    //
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);
    
    if(class_addMethod(c, origSEL,method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod))){
        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod,overrideMethod);
    }
    //    IMP myIMP = imp_implementationWithBlock(^(id _self,id object, NSString *key) {
    //        NSLog(@"Hello %@ %@",[_self class], key);
    //        [_self setDictionaryObject:object forKey:key];
    //    });
    //    class_addMethod(c,origSEL,myIMP,"myIMP");
    
}
//+ (BOOL)resolveInstanceMethod:(SEL)aSelector {
//    if (aSelector == @selector(setDictionaryObject:forKey:)) {
//        class_addMethod([NSMutableDictionary class], aSelector,(IMP)setDictionaryObject,"setDictionaryObject");
//        return YES;
//    }
//    return [super resolveInstanceMethod:aSelector];
//}
//void setDictionaryObject(id self,IMP cmd,id object, id key){
//    [self setDictionaryObject:object forKey:key];
//}
- (void)setDictionaryObject:(id)anObject forKey:(id)key{
    BOOL ok = YES;
    if (anObject == nil) {
        ok = NO;
    }else if (anObject == NULL) {
        ok = NO;
    }else if ([anObject isEqual:[NSNull class]]) {
        ok = NO;
    }
    if (ok) {
        [self setObject:anObject forKey:key];
    }else {
        [self setObject:@"" forKey:key];
    }
}
- (id)objectNotNULLForKey:(id)key{
    if (key == nil) {
        return @"";
    }else if(key == NULL){
        return @"";
    }
    id anObject = [self objectForKey:key];
    if (anObject == nil) {
        return @"";
    }else if (anObject == NULL) {
        return @"";
    }else if ([anObject isEqual:[NSNull class]]) {
        return @"";
    }else{
        return anObject;
    }
}
@end

@implementation NSUserDefaults (extent)
- (void)setUserDefaultObject:(id)anObject forKey:(id)key{
    BOOL ok = YES;
    if (anObject == nil || key == nil) {
        ok = NO;
    }else if (anObject == NULL || key == NULL) {
        ok = NO;
    }else if ([anObject isKindOfClass:[NSNull class]] || [key isKindOfClass:[NSNull class]]) {
        ok = NO;
    }
    
    if (ok) {
        [self setObject:anObject forKey:key];
    }else {
        [self setObject:@"" forKey:key];
    }
}
- (id)objectNotNULLForKey:(id)key{
    if (key == nil) {
        return @"";
    }else if(key == NULL){
        return @"";
    }
    id anObject = [self objectForKey:key];
    if (anObject == nil) {
        return @"";
    }else if (anObject == NULL) {
        return @"";
    }else if ([anObject isEqual:[NSNull class]]) {
        return @"";
    }else{
        return anObject;
    }
}
@end

@implementation NSDictionary (extent)
- (id)objectNotNULLForKey:(id)key{
    if (key == nil) {
        return @"";
    }else if(key == NULL){
        return @"";
    }
    id anObject = [self objectForKey:key];
    if (anObject == nil) {
        return @"";
    }else if (anObject == NULL) {
        return @"";
    }else if ([anObject isEqual:[NSNull class]]) {
        return @"";
    }else{
        return anObject;
    }
}
@end

