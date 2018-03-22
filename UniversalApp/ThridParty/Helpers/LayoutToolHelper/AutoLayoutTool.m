//
//  AutoLayoutTool.m
//
//  AutoLayout工具类
//  Created by ios on 15/7/6.
//  Copyright (c) 2015年 NB. All rights reserved.

#import "AutoLayoutTool.h"

@implementation AutoLayoutTool

+(void)setViewWithWidth:(NSString*)width andHeight:(NSString*)height andX:(NSString*)x andY:(NSString*)y andView:(UIView *)view
{
    offAutoSizing(view);
    
    NSString * H_constraintsFormat = [NSString stringWithFormat:@"H:|-%@-[view(%@)]",x,width];
    
    NSString * V_constraintsFormat = [NSString stringWithFormat:@"V:|-%@-[view(%@)]",y,height];
    
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:H_constraintsFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];

    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:V_constraintsFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

+(void)setViewsLayoutWithLayoutType:(LayoutType)layoutType andViews:(NSArray*)viewsArray andViewsNameArray:(NSArray*)namesArray andSonDistance:(NSString*)S_distance andParentDistance:(NSString*)P_distance andAnotherSideLength:(NSString*)anotherSideLength andAnotherCoordinate:(NSString*)anotherCoordinate andPriority:(int)priority andIsSquare:(BOOL)isSquare
{
    /*
     *Part.1为约束方向相关代码 Part.2为欠约束方向
     */
    
    //Part.1
    NSMutableString * constraintsFormat = [NSMutableString string];
    NSMutableDictionary * bindings = [NSMutableDictionary dictionary];
    NSString * viewName = @"";
    NSLayoutAttribute attribute;
    //Part.2
    NSMutableString * anotherFormat = [NSMutableString string];
    
    switch (layoutType)
    {
        case HorizontalType:
            [constraintsFormat appendString:@"H:|-"];
            [anotherFormat appendString:@"V:|-"];
            attribute = NSLayoutAttributeCenterY;
            break;
            
        case VerticalType:
            [constraintsFormat appendString:@"V:|-"];
            [anotherFormat appendString:@"H:|-"];
            attribute = NSLayoutAttributeCenterX;
            break;
    }
    //Part.1
    [constraintsFormat appendString:[NSString stringWithFormat:@"%@-",P_distance]];
    //Part.2
    [anotherFormat appendString:[NSString stringWithFormat:@"%@@%d-",anotherCoordinate,priority]];

    for (int num = 0; num<viewsArray.count; num++)
    {
        //Part.1
        viewName = namesArray[num];
        
        offAutoSizing(viewsArray[num]);
        
        if (num==0) {
            [constraintsFormat appendString:[NSString stringWithFormat:@"[%@]-",viewName]];
        }else{
            [constraintsFormat appendString:[NSString stringWithFormat:@"[%@(%@)]-",viewName,namesArray[0]]];
        }
        //        num==0?[constraintsFormat appendString:[NSString stringWithFormat:@"[%@]-",viewName]]:[constraintsFormat appendString:[NSString stringWithFormat:@"[%@(%@)]-",viewName,namesArray[0]]];
        
        if (num==viewsArray.count-1) {
            [constraintsFormat appendString:[NSString stringWithFormat:@"%@-|",P_distance]];
        }else{
            [constraintsFormat appendString:[NSString stringWithFormat:@"%@-",S_distance]];
        }
        //        num==viewsArray.count-1?[constraintsFormat appendString:[NSString stringWithFormat:@"%@-|",P_distance]]:[constraintsFormat appendString:[NSString stringWithFormat:@"%@-",S_distance]];

        
        bindings[viewName] = viewsArray[num];
        
        //Part.2
        if (!isSquare) {
            [[viewsArray[0] superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%@",anotherFormat,[NSString stringWithFormat:@"[%@(%@)]",viewName,anotherSideLength]] options:0 metrics:nil views:@{viewName:viewsArray[num]}]];
        }
        if (num>0) {
            [[viewsArray[0] superview] addConstraint:[NSLayoutConstraint constraintWithItem:viewsArray[num] attribute:attribute relatedBy:NSLayoutRelationEqual toItem:viewsArray[0] attribute:attribute multiplier:1.0 constant:0]];
        }
    }
    
    //Part.1
    [[viewsArray[0] superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintsFormat options:0 metrics:nil views:bindings]];
    
    //Part.2
    if (!isSquare) {
        return;
    }
    for (int num = 0; num<viewsArray.count; num++) {
        [[viewsArray[num] superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%@",anotherFormat,[NSString stringWithFormat:@"[%@]",viewName]] options:0 metrics:nil views:@{viewName:viewsArray[num]}]];
        [viewsArray[num] addConstraint:[NSLayoutConstraint constraintWithItem:viewsArray[num] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewsArray[num] attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
}

+(void)setViewWithWidthAndheightScale:(float)scale andFirstDistance:(NSString *)F_distance andSecondDistance:(NSString *)S_distance andAnotherCoordinate:(NSString *)anotherCoordinate andView:(UIView *)view andPriority:(int)priority andLayoutType:(LayoutType)layoutType
{
    offAutoSizing(view);
    NSMutableString * constraintsFormat = [NSMutableString string];
    NSMutableString * anotherFormat = [NSMutableString string];
    switch (layoutType)
    {
        case HorizontalType:
            [constraintsFormat appendString:@"H:|-"];
            [anotherFormat appendString:@"V:|-"];
            break;
            
        case VerticalType:
            [constraintsFormat appendString:@"V:|-"];
            [anotherFormat appendString:@"H:|-"];
            break;
    }
    
    [constraintsFormat appendString:[NSString stringWithFormat:@"%@-[view]-%@-|",F_distance,S_distance]];
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintsFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%@@%d-[view]",anotherFormat,anotherCoordinate,priority] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:scale constant:0]];
}

+(void)setViewWithHorizontalDistances:(NSArray *)H_distances andVerticalTypeDistances:(NSArray *)V_distances andView:(UIView *)view
{
    offAutoSizing(view);
    NSMutableString * H_format = [NSMutableString string];
    NSMutableString * V_format = [NSMutableString string];
    [H_format appendString:[NSString stringWithFormat:@"H:|-%@-[view]-%@-|",H_distances[0],H_distances[1]]];
    [V_format appendString:[NSString stringWithFormat:@"V:|-%@-[view]-%@-|",V_distances[0],V_distances[1]]];
    [[view superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:H_format options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [[view superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:V_format options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

+(void)setViewWithWidth:(float)width andHeight:(float)height andView:(UIView *)view
{
    offAutoSizing(view);
    NSLayoutConstraint * H_constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    NSLayoutConstraint * V_constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [view addConstraint:H_constraint];
    [view addConstraint:V_constraint];
}
+(void)setConstraintWithView:(UIView *)First_view attribute:(NSLayoutAttribute)F_attribute relatedBy:(NSLayoutRelation)relation toView:(UIView *)Second_view attribute:(NSLayoutAttribute)S_attribute multiplier:(float)multiplier constant:(float)constant andMainView:(UIView *)Main_view
{
     NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:First_view attribute:F_attribute relatedBy:relation toItem:Second_view attribute:S_attribute multiplier:multiplier constant:constant];
    [Main_view addConstraint:constraint];
}
+(void)offAutoSizingWithView:(UIView *)view
{
    offAutoSizing(view);
}
+(void)setViewWithFirstDistance:(NSString *)F_distance SecondDistance:(NSString *)S_distance andScale:(float)scale andView:(UIView *)view andLayoutType:(LayoutType)layoutType
{
    offAutoSizing(view);
    NSMutableString * format = [NSMutableString string];
    switch (layoutType) {
        case HorizontalType:
            [format appendString:@"H:|-"];
            break;
            
        case VerticalType:
            [format appendString:@"V:|-"];
            break;
    }
    [[view superview] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@%@-[view]-%@-|",format,F_distance,S_distance] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:scale constant:0]];
}
@end
