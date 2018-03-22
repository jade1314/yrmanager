//
//  UIPerspectiveView_Cell.m
//  PanGu
//  轮播图展示界面
//  Created by jade on 16/7/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UIPerspectiveView_Cell.h"

@implementation UIPerspectiveView_Cell{
    
    CGPoint startPoint;
    
    BOOL bMove;


}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        
        _label.backgroundColor = [UIColor orangeColor];
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        
        [self bindSwipe];
        
        [self bindTap];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    //时刻改变大小
    _label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

}
- (void)bindSwipe {
    //向右轻扫手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:recognizer];
    
    //向左轻扫手势
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:recognizer];
}
/**
 *  处理轻扫手势
 *
 *  @param recognizer 轻扫手势识别器对象实例
*/
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    NSLog(@"没事 就扫两下子");
    //代码块方式封装操作方法
    void (^positionOperationUp)() = ^() {
        if ([_delegate respondsToSelector:@selector(handleSwipeUpAction)]) {
            [_delegate handleSwipeUpAction];
        }
    };
    
    void (^positionOperationDown)() = ^() {
        
        if ([_delegate respondsToSelector:@selector(handleSwipeDownAction)]) {
            [_delegate handleSwipeDownAction];
        }
        
    };
    
    //根据轻扫方向，进行不同控制
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft: {
            break;
        }
        case UISwipeGestureRecognizerDirectionUp: {
            positionOperationUp();
            break;
        }
        case UISwipeGestureRecognizerDirectionDown: {
            positionOperationDown();
            break;
        }
    }
}
/**
 *  绑定点按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindTap{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:recognizer];
}
/**
 *  处理点按手势
 *
 *  @param recognizer 点按手势识别器对象实例
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"看啥  就点你了 咋滴");
    
    if ([_delegate respondsToSelector:@selector(handleTapAction)]) {
        [_delegate handleTapAction];
    }

}

#pragma mark 手指在屏幕上面滑动的距离
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSLog(@"开始滑动");
    
    UITouch *touch = [touches anyObject];
    CGPoint pointone = [touch locationInView:self];//获得初始的接触点
    startPoint  = pointone;
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    //imgViewTop是滑动后最后接触的View
    CGPoint pointtwo = [touch locationInView:self];  //获得滑动后最后接触屏幕的点
    
    if(fabs(pointtwo.y-startPoint.y)>0)
    {  //判断两点间的距离
        bMove = YES;
    }
    
    if ([_delegate respondsToSelector:@selector(handlePointDistance:)]) {
        [_delegate handlePointDistance:(pointtwo.y-startPoint.y)];
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    NSLog(@"滑动结束");
    
    UITouch *touch = [touches anyObject];
    CGPoint pointtwo = [touch locationInView:self];  //获得滑动后最后接触屏幕的点
    if((fabs(pointtwo.y-startPoint.y)>0)&&(bMove))
    {
        //判断点的位置关系 上滑动
        if(pointtwo.y-startPoint.y<0)
        {   //上滑动业务处理
            
           
        }
        //判断点的位置关系 下滑动
        else
        {   //下滑动业务处理
            
        }
    }
    
}
@end
