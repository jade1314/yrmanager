//
//  AutoLayoutTool.m
//
//  AutoLayout工具类
//  Created by ios on 15/7/6.
//  Copyright (c) 2015年 NB. All rights reserved.

#import <UIKit/UIKit.h>
//关闭普通的大小设置
#define offAutoSizing(view) [view setTranslatesAutoresizingMaskIntoConstraints:NO]

typedef enum layoutType{
    HorizontalType,
    VerticalType
}LayoutType;

@interface AutoLayoutTool : NSObject
/*
 *方法功能：（取替frame）
  为单个视图在其父视图中设置空间位置。可实现模糊赋值(>= OR == OR <=)。跟AutoSizing(frame)类似。
 *参数解释：
  width：视图宽 height：视图高  X:水平坐标  Y：垂直坐标  view：该视图
 */
+(void)setViewWithWidth:(NSString*)width andHeight:(NSString*)height andX:(NSString*)x andY:(NSString*)y andView:(UIView*)view;


/*
 *方法功能：（边距固定的单个视图）
 布局单个视图，边距固定。
 *参数解释：
 H_distances:水平间距组 V_distances:垂直间距组 view:需要约束的视图
 */
+(void)setViewWithHorizontalDistances:(NSArray*)H_distances andVerticalTypeDistances:(NSArray*)V_distances andView:(UIView*)view;


/*
 *方法功能：（宽高比例固定布局,欠约束方向坐标可二次约束）
 布局单个视图左右边距固定，宽高比例一定。
 *参数解释：
 scale:宽高比例 L_distance:左边距 R_distance:右边距 anotherCoordinate:欠约束方向的视图坐标
 view:需要约束的视图 priority:欠约束方向优先级
 */
+(void)setViewWithWidthAndheightScale:(float)scale andFirstDistance:(NSString*)F_distance andSecondDistance:(NSString*)S_distance andAnotherCoordinate:(NSString*)anotherCoordinate andView:(UIView*)view andPriority:(int)priority andLayoutType:(LayoutType)layoutType;

/*
 *方法功能：(轴对称布局,欠约束方向坐标可二次约束)
 遵循轴对称原则，为视图(一个或多个)设置相对布局，支持模糊赋值。
 *参数解释：
 layoutType：布局类型(水平，垂直)  viewsArray:视图组 namesArray：视图名称组
 P_distance：父间距(最靠近父视图的子视图距离主视图的边距) S_distance:子间距(相邻两个视图之间的边距)
 anotherSideLength:欠约束方向的视图边长 
 anotherCoordinate：欠约束方向的视图坐标
 priority:欠约束方向坐标约束的优先级
 isSquare:是否创建正方形。(是正方形anotherSideLength属性失效)
 *注：参数不要传nil。且根据苹果APP审美观念，P_distance为8，S_distance为20。
 可通过为第一个视图再添加约束，实现视图组位置的改变。
 */
+(void)setViewsLayoutWithLayoutType:(LayoutType)layoutType andViews:(NSArray*)viewsArray andViewsNameArray:(NSArray*)namesArray andSonDistance:(NSString*)S_distance andParentDistance:(NSString*)P_distance andAnotherSideLength:(NSString*)anotherSideLength andAnotherCoordinate:(NSString*)anotherCoordinate andPriority:(int)priority andIsSquare:(BOOL)isSquare;

/*********************欠约束的方法(需要多个配合使用)***********************/
/*
 *方法功能：
  禁用视图AutoSizing
 *参数解释：
  view:需要禁用AutoSizing的视图
 */
+(void)offAutoSizingWithView:(UIView*)view;

/*
 *方法功能：（宽高固定的单个视图）
 布局单个视图，宽高固定。
 *参数解释：
 width:宽 height:高 view:需要约束的视图
 */
+(void)setViewWithWidth:(float)width andHeight:(float)height andView:(UIView*)view;

/*
 *方法功能：（规定方向上边距一定，宽高比例一定）
  布局单个视图。
 *参数解释：
 width:宽 height:高 view:需要约束的视图
 */
+(void)setViewWithFirstDistance:(NSString*)F_distance SecondDistance:(NSString*)S_distance andScale:(float)scale andView:(UIView*)view andLayoutType:(LayoutType)layoutType;

/*
 *方法功能：（为两个视图间添加约束）
  为两视图添加单个约束，实现布局。
 *参数解释：
  First_view:第一个视图 F_attribute:第一个视图属性 relation:两属性规则关系 Second_view:第二个视图
  S_attribute:第二个视图属性 multiplier:倍数 constant:偏移量or大小
 */
+(void)setConstraintWithView:(UIView*)First_view attribute:(NSLayoutAttribute)F_attribute relatedBy:(NSLayoutRelation)relation toView:(UIView*)Second_view attribute:(NSLayoutAttribute)S_attribute multiplier:(float)multiplier constant:(float)constant andMainView:(UIView*)Main_view;
/*****************************************************************/

@end
