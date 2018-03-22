//
//  UIPerspectiveView.m
//  PanGu
//  轮播图
//  Created by jade on 16/7/2.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UIPerspectiveView.h"
#import "UIPerspectiveView_Cell.h"

#define ClassTemplateView @"UIPerspectiveView_Cell"
#define borderWidth 40
#define borderMiniWidth 30
#define borderMiniHeight 20

#define kBaseTag 10001

@interface UIPerspectiveView ()<UIScrollViewDelegate,UIPerspectiveView_CellDelegate>
//模板数据源
@property(nonatomic,strong)NSArray *platePerspectiveDataArr;
//当前显示页面
@property(nonatomic,assign)NSInteger currentPerspectivePageIndex;
//记录当前使用的地板模式
@property(nonatomic,assign)NSInteger pagePerspectiveCount;
//记录轮数
@property(nonatomic,assign)NSInteger orientationPerspectiveIndex;
//总轮数
@property(nonatomic,assign)NSInteger orientationIndexPerspectiveTotal;
//余数
@property(nonatomic,assign)NSInteger remainderPerspectiveIndex;

@end

@implementation UIPerspectiveView{
    
    //底板
    UIScrollView *scrollview;
    
    CGFloat realHeight;
    CGFloat realWidth;
    
}
//懒加载
-(NSArray *)realPerspectiveDataArr{
    if (_realPerspectiveDataArr == nil) {
        if ([_delegate respondsToSelector:@selector(getRealPerspectiveData)]) {
            _realPerspectiveDataArr = [_delegate getRealPerspectiveData];
        }
    }
    return _realPerspectiveDataArr;
}
//初始化
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //(UIScrollView/view)之间的尺寸
        float viewWidth;
        
        viewWidth =  frame.size.width - borderWidth * 2;
        
        scrollview = ({
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(borderWidth, 0, viewWidth, frame.size.height)];
            scroll.pagingEnabled = YES;
            scroll.clipsToBounds = NO;
            scroll;
        });
        
        [self addSubview:scrollview];
        self.clipsToBounds = YES;
        realHeight = scrollview.height - borderMiniHeight * 2;
        realWidth = scrollview.width - borderMiniWidth * 2;
        
        self.backgroundColor = [UIColor clearColor];
        scrollview.backgroundColor = [UIColor clearColor];
        scrollview.showsHorizontalScrollIndicator = NO;
        //设置初始偏移量
        scrollview.contentInset = UIEdgeInsetsMake(0, -scrollview.size.width, 0, 0);
        scrollview.delegate = self;
    }
    
    return self;
}
-(void)dealloc{
    
    if (scrollview) {
        scrollview = nil;
    }
    
    if (_realPerspectiveDataArr) {
        _realPerspectiveDataArr = nil;
    }
    
    if (_platePerspectiveDataArr) {
        _platePerspectiveDataArr = nil;
    }


}
//执行布局方法
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    /**********先处理数据，由数据判断界面的布局结构***********/
    [self getAGroupData];
    
}
//计算缩放倍数
- (void)adjustSonSubviews:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollview.width;
    index = MIN(_platePerspectiveDataArr.count - 1, MAX(0, index));
    NSLog(@"用于计算移动量的页面________%zd",index);
    CGFloat scale = (scrollView.contentOffset.x - scrollview.width * index) / scrollview.width;
    NSLog(@"scale0________%f",scale);
    
    if (_platePerspectiveDataArr.count > 0) {
        
        CGFloat height;
        CGFloat width;
        CGFloat x;
        CGFloat y;
        
        if (scale < 0.0) {//这种情况不会出现
//            scale = 1 - MIN(1.0, ABS(scale));
//            
//            NSLog(@"scale1________%f",scale);
//            
//            UIPerspectiveView_Cell *leftView = _platePerspectiveDataArr[index];
//            leftView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scale].CGColor;
//            height = realHeight + (scrollview.height - realHeight) * scale;
//            width = realWidth + (scrollview.width - realWidth) * scale;
//            leftView.frame = CGRectMake(-(width - realWidth) / 2, -(height - realHeight), width, height);
//            
//            if (index + 1 < _platePerspectiveDataArr.count) {
//                UIPerspectiveView_Cell *rightView = _platePerspectiveDataArr[index + 1];
//                rightView.frame = CGRectMake(0, 0, realWidth, realHeight);
//                rightView.layer.borderColor = [UIColor clearColor].CGColor;
//            }
            
        } else if (scale <= 1.0) {
            if (index + 1 >= _platePerspectiveDataArr.count) {//这种情况不会出现
                
//                scale = 1 - MIN(1.0, ABS(scale));
//                
//                 NSLog(@"scale2________%f",scale);
//                
//                UIPerspectiveView_Cell *imgView = _platePerspectiveDataArr[_platePerspectiveDataArr.count - 1];
//                imgView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scale].CGColor;
//                height = realHeight + (scrollview.height - realHeight) * scale;
//                width = realWidth + (scrollview.width - realWidth) * scale;
//                imgView.frame = CGRectMake(-(width - realWidth) / 2, -(height - realHeight), width, height);
//                
            } else {//正常范围内
                CGFloat scaleLeft = 1 - MIN(1.0, ABS(scale));
                NSLog(@"scaleLeft________%f",scaleLeft);
                UIPerspectiveView_Cell *leftView = _platePerspectiveDataArr[index];
                leftView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scaleLeft].CGColor;
                height = realHeight + borderMiniHeight * 2 * scaleLeft;
                width = realWidth + borderMiniWidth * 2 * scaleLeft;
                NSLog(@"width________%f",width);
                x = borderMiniWidth*(1-scaleLeft);
                y = borderMiniHeight*(1-scaleLeft);
                leftView.frame = CGRectMake(x, y, width, height);
                
                CGFloat scaleRight = MIN(1.0, ABS(scale));
                 NSLog(@"scaleRight________%f",scaleRight);
                UIPerspectiveView_Cell *rightView = _platePerspectiveDataArr[index + 1];
                rightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scaleRight].CGColor;
                height = realHeight + borderMiniHeight * 2 * scaleRight;
                width = realWidth + borderMiniWidth * 2  * scaleRight;
                x = borderMiniWidth*(1-scaleRight);
                y = borderMiniHeight*(1-scaleRight);
                rightView.frame = CGRectMake(x, y, width, height);
            }
        }
        //还原
        for (UIPerspectiveView_Cell *imgView in _platePerspectiveDataArr) {
            if (imgView.tag != index + kBaseTag && imgView.tag != (index + kBaseTag + 1) ) {
                imgView.frame = CGRectMake(borderMiniWidth, borderMiniHeight, realWidth, realHeight);
                imgView.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
}
#pragma mark  UIScrollViewDelegate
//开始跑
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    //得到当前位置
    _currentPerspectivePageIndex=[self getCurrentPosition];
    
    NSLog(@"粗略计算的页码%ld",_currentPerspectivePageIndex);
    
    if (_currentPerspectivePageIndex == 1) {
        
        //防止误操作
        scrollview.userInteractionEnabled = NO;
        
    }
    
    [self adjustSonSubviews:sender];
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    scrollview.scrollEnabled=NO;
}
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    if (_currentPerspectivePageIndex==1) {//滑动到到首页之前跳转到末页
        
        _orientationPerspectiveIndex--;//轮数
        
        //控制滚动轮数不越界
        if (_orientationPerspectiveIndex < 0) {
            _orientationPerspectiveIndex = _orientationIndexPerspectiveTotal-1;
        }
        
        //根据余数跳转到响应的界面
        if (_remainderPerspectiveIndex == 0 && _pagePerspectiveCount ==3 && _orientationPerspectiveIndex == _orientationIndexPerspectiveTotal-1) {
            //跳转之前要把待跳转的页面变的和现在一样
            //跳到第三界面
            [scrollView setContentOffset:CGPointMake(4*scrollview.frame.size.width, 0)];
            
        }else if (_remainderPerspectiveIndex == 1 && _pagePerspectiveCount ==3 && _orientationPerspectiveIndex == _orientationIndexPerspectiveTotal-1){
            //跳到第一界面
            [scrollView setContentOffset:CGPointMake(2*scrollview.frame.size.width, 0)];
        }else if (_remainderPerspectiveIndex == 2 && _pagePerspectiveCount ==3 && _orientationPerspectiveIndex == _orientationIndexPerspectiveTotal-1){
            //跳到第二界面
            [scrollView setContentOffset:CGPointMake(3*scrollview.frame.size.width, 0)];
            
        }else{
            //跳转到与之相关的界面
            [scrollView setContentOffset:CGPointMake((_pagePerspectiveCount + 1)*scrollview.frame.size.width, 0)];
            
        }
        
        
    }else if (_currentPerspectivePageIndex== _pagePerspectiveCount + 2) {//滑动到到末页之后跳转到首页
        
        _orientationPerspectiveIndex++;//轮数
        
        //控制滚动轮数不越界
        if (_orientationPerspectiveIndex > _orientationIndexPerspectiveTotal) {
            _orientationPerspectiveIndex = 0;
        }
        
        [scrollView setContentOffset:CGPointMake(2 * scrollview.frame.size.width, 0)];
        
    }
    
    //动态赋值
    [self dynamicLoadingWithData:_platePerspectiveDataArr andCurrentPage:_currentPerspectivePageIndex];
    
}

#pragma mark 动态加载不同的页面
-(void)dynamicLoadingWithData:(NSArray *)dataArr andCurrentPage:(NSInteger)page{
    
    //模板类型
    UIView * View;
    
    if (dataArr.count == 1) {//这种情况下  数据源只有一条数据
        
        View = dataArr[0];
        
        [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View];
        
    }else if (dataArr.count == 6){//这种情况下  数据源只有二条数据
        //量不大 直接写死
        View = dataArr[1];
        [self webViewLoadUrl:_realPerspectiveDataArr[1] forView:View];
        View = dataArr[2];
        [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View];
        View = dataArr[3];
        [self webViewLoadUrl:_realPerspectiveDataArr[1] forView:View];
        View = dataArr[4];
        [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View];
        
    }else if (dataArr.count == 7){//动态循环加载不同资源
        
        UIView * View0;
        UIView * View1;
        UIView * View2;
        UIView * View3;
        UIView * View4;
        
        //先默认是从右边滑动
        View0 = dataArr[1];
        View1 = dataArr[2];
        View2 = dataArr[3];
        View3 = dataArr[4];
        View4 = dataArr[5];
        
        NSInteger one;
        
        NSInteger two;
        
        NSInteger three;
        
        //分别计算不同的页面 应该展示与之对应的界面
        one = 3*_orientationPerspectiveIndex;
        two = 1+ one;
        three = 2 + one;
        
        NSLog(@"第%zd轮,第%zd页",_orientationPerspectiveIndex,page);
        
        if (page == 1) {
            
            [self webViewLoadUrl:_realPerspectiveDataArr[three] forView:View0];
            
            
        }else if (page == 2){
            
            if (one > _realPerspectiveDataArr.count-1) {
                
                [self getZeroWithView:View1];
                [self webViewLoadUrl:_realPerspectiveDataArr[1] forView:View2];
                [self webViewLoadUrl:[_realPerspectiveDataArr lastObject] forView:View0];
                
            }else{
                
                [self webViewLoadUrl:_realPerspectiveDataArr[one] forView:View1];
                if (one == 0) {
                    [self webViewLoadUrl:[_realPerspectiveDataArr lastObject] forView:View0];
                }else{
                    [self webViewLoadUrl:_realPerspectiveDataArr[one-1] forView:View0];
                }
                if (two < _realPerspectiveDataArr.count) {
                    [self webViewLoadUrl:_realPerspectiveDataArr[two] forView:View2];
                }else{
                    if (_remainderPerspectiveIndex == 1) {//余数为1
                        [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View2];
                    }else{
                        [self webViewLoadUrl:_realPerspectiveDataArr[two] forView:View2];
                    }
                }
        
            }
            
        }else if (page == 3){
            
            if (two > _realPerspectiveDataArr.count-1) {
                
                [self getZeroWithView:View1];
                [self webViewLoadUrl:_realPerspectiveDataArr[1] forView:View2];
                [self webViewLoadUrl:[_realPerspectiveDataArr lastObject] forView:View0];
                
                
            }else{
                
                [self webViewLoadUrl:_realPerspectiveDataArr[two] forView:View2];
                [self webViewLoadUrl:_realPerspectiveDataArr[one] forView:View1];
                if (three <  _realPerspectiveDataArr.count) {
                    [self webViewLoadUrl:_realPerspectiveDataArr[three] forView:View3];
                }else{
                    [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View3];
                }
            }
            
        }else if (page == 4){
            
            if (three > _realPerspectiveDataArr.count-1) {
                
                [self getZeroWithView:View1];
                [self webViewLoadUrl:_realPerspectiveDataArr[1] forView:View2];
                [self webViewLoadUrl:[_realPerspectiveDataArr lastObject] forView:View0];
                
            }else{
                
                [self webViewLoadUrl:_realPerspectiveDataArr[three] forView:View3];
                if (three + 1 > _realPerspectiveDataArr.count-1) {
                    //增加的情况  保证最后一个和第一个优先变化
                    [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View4];
                    [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View1];
                }else{
                    //增加的情况  保证最后一个和第一个优先变化
                    [self webViewLoadUrl:_realPerspectiveDataArr[three + 1] forView:View4];
                    [self webViewLoadUrl:_realPerspectiveDataArr[three + 1] forView:View1];
                }
                //减少的情况下
                [self webViewLoadUrl:_realPerspectiveDataArr[two] forView:View2];

            }
            
        }else if (page == 5){
            
            [self webViewLoadUrl:_realPerspectiveDataArr[one] forView:View4];
            
        }
        
        View0 = nil;
        View1 = nil;
        View2 = nil;
        View3 = nil;
        View4 = nil;
        
    }
    
    View = nil;
    
    scrollview.scrollEnabled = YES;
    
}
//归零
-(void)getZeroWithView:(UIView *)View{
    
    //滚动到首位
    [scrollview setContentOffset:CGPointMake(2 * scrollview.frame.size.width, 0)];
    
    if (_realPerspectiveDataArr.count > 0) {
        
        [self webViewLoadUrl:_realPerspectiveDataArr[0] forView:View];
    }
    
    _orientationPerspectiveIndex = 0;
}
//获得当前位置
-(int)getCurrentPosition{
    
    CGFloat pageWidth = scrollview.frame.size.width;
    
    return floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
#pragma mark 创建数据源
-(void)getAGroupData{
    if (self.realPerspectiveDataArr) {
        [self dealWithData:CGRectMake(0, 0, scrollview.width, scrollview.height) andDataArr:self.realPerspectiveDataArr];
    }

}
-(void)dealWithData:(CGRect)frame andDataArr:(NSArray *)realDataArray{
    
    //计算轮数
    _orientationIndexPerspectiveTotal = realDataArray.count/3;
    //计算余数
    _remainderPerspectiveIndex =realDataArray.count%3;
    //计算真实轮数
    if (_remainderPerspectiveIndex>0) {
        _orientationIndexPerspectiveTotal++;
    }
    
    //根据真实的数据源确定使用哪一种模板
    if (realDataArray.count == 1) {
        _pagePerspectiveCount = 1;
    }else if (realDataArray.count == 2){
        _pagePerspectiveCount = 2;
    }else if (realDataArray.count >= 3){
        _pagePerspectiveCount = 3;
    }else{
        return ;
    }
    
    if (_platePerspectiveDataArr.count == 0) {
        
        __block NSArray *dataArr;
        //确定底层的模版
        [self initWithView:frame andContentCount:_pagePerspectiveCount andContentViewBlock:^(NSArray *content) {
            //拿到模板 自定义模板类型
            dataArr = [self creatNewContentViewWith:content];
            
        }];
        //获得模板源
        _platePerspectiveDataArr = [[NSMutableArray alloc] initWithArray:dataArr];
        
        dataArr = nil;
    }
    
    //初始化的时候进入的界面
    if (_currentPerspectivePageIndex < _platePerspectiveDataArr.count && _currentPerspectivePageIndex >= 0) {
        
        UIPerspectiveView_Cell *cell;
        
        cell = _platePerspectiveDataArr[_currentPerspectivePageIndex];
        
        cell.frame = CGRectMake(0, 0, scrollview.size.width, scrollview.size.height);
        
        cell = nil;
    }
    
    //暂时初始化的界面
    
    [self dynamicLoadingWithData:_platePerspectiveDataArr andCurrentPage:[self getCurrentPosition]];
    
}
#pragma mark 决定轮播上面暂时的view类型
//布地板
-(void)initWithView:(CGRect)rect andContentCount:(NSInteger)count andContentViewBlock:(void(^)(NSArray *content))contentArr{
    
    UIView *contentView;
    NSMutableArray *contentArray;
    
    contentArray = [[NSMutableArray alloc] init];
    
    if (count == 1) {
        //重新固定内容尺寸(不考虑间隔)
        scrollview.contentSize = CGSizeMake(rect.size.width, rect.size.height);
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        [scrollview addSubview:contentView];
        scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        contentView.backgroundColor = [UIColor clearColor];
        //统筹具体的模板
        [contentArray addObject:contentView];
        
    }else if (count == 2){
        /************两个界面支持轮播功能,所以是2＋2模式*****************/
        //重新固定内容尺寸
        scrollview.contentSize = CGSizeMake(rect.size.width * (2 + 2 + 1), rect.size.height);
        
        for (int i = 0 ; i < (4 + 2); i++) {
            //创建六个view
            contentView = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width ) * i , 0, rect.size.width, rect.size.height)];
            contentView.backgroundColor = [UIColor clearColor];
            [scrollview addSubview:contentView];
            //统筹具体的模板
            [contentArray addObject:contentView];
        }
        //初始偏移量
        [scrollview setContentOffset:CGPointMake(2 * rect.size.width , 0)];
        
    }else if (count == 3){
        
        /************三个界面支持轮播功能,所以是3＋2模式*****************/
        //重新固定内容尺寸(考虑间隔)
        scrollview.contentSize = CGSizeMake((rect.size.width * (3 + 2 + 1)), rect.size.height);
        for (int i = 0 ; i < (5+2); i++) {
            //创建七个view
            contentView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width * i , 0, rect.size.width, rect.size.height)];
            contentView.backgroundColor = [UIColor clearColor];
            [scrollview addSubview:contentView];
            //统筹具体的模板
            [contentArray addObject:contentView];
    
        }
        
        //初始偏移量
        [scrollview setContentOffset:CGPointMake(2 * rect.size.width , 0)];
        
        
    }else{
        
        return;
    }
    //数据外传
    if (contentArr) {
        contentArr(contentArray);
    }
    /**********值空**********/
    if (contentArr) {
        [contentArray removeAllObjects];
        contentArray = nil;
    }
    
    contentView = nil;
    
}

//创建内容模板类型
-(NSArray *)creatNewContentViewWith:(NSArray *)contentViewArr{
    
    /******模板类型****/
    UIPerspectiveView_Cell * cellPerspective;
    //底板
    UIView *view;
    
    NSMutableArray * dataArr;
    
    dataArr= [[NSMutableArray alloc] init];
    
    switch (contentViewArr.count) {
        case 1:
            //获得底板
            view = (UIView*)contentViewArr[0];
            //创建各种需求内容暂时板
            cellPerspective = (UIPerspectiveView_Cell*)[self singleViewWithSize:view.bounds];
            [view addSubview:cellPerspective];
            cellPerspective.tag = 10001;
            cellPerspective.backgroundColor = [UIColor clearColor];
            cellPerspective.delegate = self;
            //统筹
            [dataArr addObject:cellPerspective];
            
            break;
            
        case 6:
            
            for (int i = 0 ; i< 6 ; i ++ ) {
                
                view = (UIView*)contentViewArr[i];
                cellPerspective = (UIPerspectiveView_Cell*)[self singleViewWithSize:view.bounds];
                [view addSubview:cellPerspective];
                cellPerspective.tag = 10001+i;
                cellPerspective.backgroundColor = [UIColor clearColor];
                cellPerspective.delegate = self;
                //统筹
                [dataArr addObject:cellPerspective];
                
            }
            
            break;
            
        case 7:
    
            for (int i = 0 ; i< 7 ; i ++ ) {
                view = (UIView*)contentViewArr[i];
                cellPerspective = (UIPerspectiveView_Cell*)[self singleViewWithSize:view.bounds];
                [view addSubview:cellPerspective];
                cellPerspective.tag = 10001+i;
//                cellPerspective.backgroundColor = [UIColor blueColor];
                cellPerspective.delegate = self;
                //统筹
                [dataArr addObject:cellPerspective];
            }
            
            break;
        default:
            break;
    }
    
    cellPerspective = nil;
    view = nil;
    
    return dataArr;
    
    
}
#pragma mark 创建内容
//创建内容view
-(UIView *)singleViewWithSize:(CGRect)rect{

    UIView *view;
    
    if (nil == view) {
        //决定内容模板在底板👆的位置
        view = (UIView *)[[NSClassFromString(ClassTemplateView) alloc] initWithFrame:CGRectMake(borderMiniWidth, borderMiniHeight, rect.size.width - borderMiniWidth * 2, rect.size.height - borderMiniHeight * 2)];
        if (view == nil) {
            return nil;
        }
    }
    
    return view;
}
//加载具体地址
-(void)webViewLoadUrl:(id)data forView:(UIView *)View{
    
    UIPerspectiveView_Cell *cell;
    
    cell = (UIPerspectiveView_Cell *)View;

    cell.label.text =(NSString *)data;

    
    cell = nil;
}

#pragma mark 修改触摸区域
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view;
    
    view = [super hitTest:point withEvent:event];
    if ([view isEqual:self])
    {
        for (UIView *subview in scrollview.subviews)
        {
            CGPoint offset = CGPointMake(point.x - scrollview.frame.origin.x + scrollview.contentOffset.x - subview.frame.origin.x,
                                         point.y - scrollview.frame.origin.y + scrollview.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event]))
            {
                return view;
            }
        }
        return scrollview;
    }
    return view;
}
#pragma mark UIPerspectiveView_CellDelegate
-(void)handleTapAction{
    
    
    
}

-(void)handleSwipeUpAction{
    
    /***********改变两边卡片的状态************/
    
    scrollview.scrollEnabled = NO;
    
    UIPerspectiveView_Cell *rightView = _platePerspectiveDataArr[_currentPerspectivePageIndex + 1];
    
    rightView.hidden = YES;
    
     UIPerspectiveView_Cell *leftView = _platePerspectiveDataArr[_currentPerspectivePageIndex - 1];
    
    leftView.hidden = YES;

    

}

-(void)handleSwipeDownAction{
    
    scrollview.scrollEnabled = YES;
    
    UIPerspectiveView_Cell *rightView = _platePerspectiveDataArr[_currentPerspectivePageIndex + 1];
    
    rightView.hidden = NO;
    
    UIPerspectiveView_Cell *leftView = _platePerspectiveDataArr[_currentPerspectivePageIndex - 1];
    
    leftView.hidden = NO;

}

-(void)handlePointDistance:(CGFloat)dictance{
    
    NSLog(@"###############%lf",dictance);
    
    if (dictance < 0) {
         //上滑动业务处理
        NSLog(@"向上滑动");
    }else{
        //下滑动业务处理
        NSLog(@"向下滑动");
    }


}

@end
