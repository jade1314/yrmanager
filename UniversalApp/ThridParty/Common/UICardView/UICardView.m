//
//  UICardView.m
//  PanGu
//
//  Created by jade on 16/6/28.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UICardView.h"
#import "UICardView_Cell.h"

#define ClassTemplateView @"UICardView_Cell"

@interface UICardView ()<UIScrollViewDelegate>

//经过处理的数据源
@property(nonatomic,strong)NSArray *realDataArr;
//当前显示页面
@property(nonatomic,assign)NSInteger currentPageIndex;
//记录当前使用的地板模式
@property(nonatomic,assign)NSInteger pageCount;
//模板数据源
@property(nonatomic,strong)NSArray *plateDataArr;
//记录轮数
@property(nonatomic,assign)NSInteger orientationIndex;
//总轮数
@property(nonatomic,assign)NSInteger orientationIndexTotal;
//余数
@property(nonatomic,assign)NSInteger remainderIndex;
//内容界面大小
@property(nonatomic,assign)CGSize contentRect;

@end


static NSInteger spaceH;

static NSInteger spaceW;

static NSInteger broadside;//侧边距离

@implementation UICardView

/*
 思路：先大体搭建起一个框架－－保证有三个view用来承载后面需要自定义的view
      架构用3＋2的模式
      view的具体样式由业务层决定
      当view的具体样式被固定之后，再由外面决定，固定业务层上面的数据（参照uitabview来写）
      如果说，view的样式定不下来，直接上uiwebview
 */

//初始化
-(instancetype)initWithFrame:(CGRect)frame andContentCount:(NSInteger)count {
    //决定本身可视界面的大小
    self = [super initWithFrame:frame];
    /******************决定间隔属性*********************/
    spaceH = 0;
    
    spaceW = 0;
    
    _contentRect = CGSizeMake(frame.size.width - spaceW * 2, frame.size.height - spaceH *2);
    
    
    broadside = (frame.size.width - _contentRect.width -spaceW)/2;
    
    if (self) {
        /**********基础属性***********/
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(_contentRect.width, 0);//初始偏移
        self.contentSize = CGSizeMake(_contentRect.width * count , frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.delegate = self;
//        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
//执行布局方法
-(void)drawRect:(CGRect)rect{
    /**********先处理数据，由数据判断界面的布局结构***********/
    [self getAGroupData];
    
}
//布地板
-(void)initWithView:(CGRect)rect andContentCount:(NSInteger)count andContentViewBlock:(void(^)(NSArray *content))contentArr{
    UIView *contentView;
    NSMutableArray *contentArray;
    
    contentArray = [[NSMutableArray alloc] init];

    if (count == 1) {
        //重新固定内容尺寸(不考虑间隔)
        self.contentSize = CGSizeMake(rect.size.width + spaceW*2, rect.size.height + spaceH*2);
        contentView = [[UIView alloc] initWithFrame:CGRectMake(spaceW, spaceH, rect.size.width, rect.size.height)];
        [self addSubview:contentView];
        //统筹具体的模板
        [contentArray addObject:contentView];
    
    }else if (count == 2){
        /************两个界面支持轮播功能,所以是2＋2模式*****************/
        //重新固定内容尺寸
        self.contentSize = CGSizeMake(((rect.size.width + spaceW*1/2) * (2 + 2) + spaceW*1/2), rect.size.height + spaceH*2);
        
        for (int i = 0 ; i < 4; i++) {
            //创建四个view
            contentView = [[UIView alloc] initWithFrame:CGRectMake((rect.size.width + spaceW*1/2) * i + spaceW*1/2, spaceH, rect.size.width, rect.size.height)];
            
            [self addSubview:contentView];
            //统筹具体的模板
            [contentArray addObject:contentView];
        }
        //初始偏移量
        [self setContentOffset:CGPointMake(rect.size.width + spaceW*1/2 - broadside, 0)];
    
    }else if (count == 3){
        
        /************三个界面支持轮播功能,所以是3＋2模式*****************/
        //重新固定内容尺寸(考虑间隔)
        self.contentSize = CGSizeMake((rect.size.width * (3 + 2)), rect.size.height);
        for (int i = 0 ; i < 5; i++) {
            //创建五个view
            contentView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width * i , 0, rect.size.width, rect.size.height)];
            
            [self addSubview:contentView];
            //统筹具体的模板
            [contentArray addObject:contentView];
        }
        
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

#pragma mark  UIScrollViewDelegate
static  NSInteger  indexPage;//记录每一次的位置
//开始跑
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //得到当前位置
    _currentPageIndex=[self getCurrentPosition];
    
    //监听 _currentPageIndex 这个值的变化,从而确定轮播页面是左滑动还是右滑动
    if (_currentPageIndex == indexPage) {
        
        
    }else if (_currentPageIndex > indexPage  && _currentPageIndex != _pageCount + 1){ //right
        //每一次改变  重新记录当前位置
        indexPage = _currentPageIndex;
        
    }else if (_currentPageIndex < indexPage && _currentPageIndex != 0){//left
        //每一次改变  重新记录当前位置
        indexPage = _currentPageIndex;
        
    }else if (_currentPageIndex == _pageCount + 1){//到了右边极限
        
        indexPage = 0;
        
    }else if (_currentPageIndex == 0){//到了左边极限
        
        indexPage = 4;

    }
}

//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPageIndex==0) {//滑动到到首页 跳转到末页
        
        _orientationIndex--;//轮数
        
        //控制滚动轮数不越界
        if (_orientationIndex < 0) {
            _orientationIndex = _orientationIndexTotal-1;
        }
        
        //根据余数跳转到响应的界面
        if (_remainderIndex == 0 && _pageCount ==3 && _orientationIndex == _orientationIndexTotal-1) {
            //跳到第三界面
            [scrollView setContentOffset:CGPointMake(_pageCount*self.frame.size.width, 0)];
        }else if (_remainderIndex ==1 && _pageCount ==3 && _orientationIndex == _orientationIndexTotal-1){
            //跳到第一界面
            [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        }else if (_remainderIndex ==2 && _pageCount ==3 && _orientationIndex == _orientationIndexTotal-1){
            //跳到第二界面
            [scrollView setContentOffset:CGPointMake((_pageCount-1)*self.frame.size.width, 0)];
        
        }else{
            //跳转到与之相关的界面
            [scrollView setContentOffset:CGPointMake(_pageCount*self.frame.size.width, 0)];
            
//            [self setContentOffset:CGPointMake((_contentRect.width + spaceW*1/2)*2 - broadside, 0)];
        }
    }else if (_currentPageIndex== _pageCount + 1) {//滑动到到末页 跳转到首页
        
        _orientationIndex++;//轮数
        //控制滚动轮数不越界
        if (_orientationIndex > _orientationIndexTotal) {
            _orientationIndex = _orientationIndexTotal-1;
        }
        
        [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        
//        [self setContentOffset:CGPointMake((_contentRect.width + spaceW*1/2)*1 - broadside, 0)];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self setContentOffset:CGPointMake((_contentRect.width + spaceW*1/2)*_currentPageIndex - broadside, 0)];
        }];
        
    }
    //动态布局
    [self dynamicLoadingWithData:_plateDataArr andCurrentPage:_currentPageIndex];
    
}

//动态加载不同的页面
-(void)dynamicLoadingWithData:(NSArray *)dataArr andCurrentPage:(NSInteger)page{
    
    //模板类型
    UIView * View;
    
    if (dataArr.count == 1) {//这种情况下  数据源只有一条数据
        
        View = dataArr[0];
        
        [self webViewLoadUrl:_realDataArr[0] forView:View];
        
    }else if (dataArr.count ==4){//这种情况下  数据源只有二条数据
        //量不大 直接写死
        View = dataArr[0];
        [self webViewLoadUrl:_realDataArr[1] forView:View];
        View = dataArr[1];
        [self webViewLoadUrl:_realDataArr[0] forView:View];
        View = dataArr[2];
        [self webViewLoadUrl:_realDataArr[1] forView:View];
        View = dataArr[3];
        [self webViewLoadUrl:_realDataArr[0] forView:View];
        
    }else if (dataArr.count == 5){//动态循环加载不同资源
        
        UIView * View0;
        UIView * View1;
        UIView * View2;
        UIView * View3;
        UIView * View4;
        
        //先默认是从右边滑动
        View0 = dataArr[0];
        View1 = dataArr[1];
        View2 = dataArr[2];
        View3 = dataArr[3];
        View4 = dataArr[4];
        
        NSInteger one;
        
        NSInteger two;
        
        NSInteger three;
        
        //分别计算不同的页面 应该展示与之对应的界面
        one = 3*_orientationIndex;
        two = 1+ one;
        three = 2 + one;
        
        NSLog(@"第%zd轮,第%zd页",_orientationIndex,page);
        
            if (page == 0) {
                
                [self webViewLoadUrl:_realDataArr[three] forView:View0];
                
                
            }else if (page == 1){
                
                if (one > _realDataArr.count-1) {
                    
                    [self getZeroWithView:View1];
                    
                }else{
                    
                    [self webViewLoadUrl:_realDataArr[one] forView:View1];
                }
                
            }else if (page == 2){
                
                if (two > _realDataArr.count-1) {
                    
                    [self getZeroWithView:View1];
                    
                }else{
                    
                    [self webViewLoadUrl:_realDataArr[two] forView:View2];
                }
                
            }else if (page == 3){
                
                if (three > _realDataArr.count-1) {
                    
                    [self getZeroWithView:View1];
                    
                }else{
                    
                    [self webViewLoadUrl:_realDataArr[three] forView:View3];
                    
                }
                
            }else if (page == 4){
                
                [self webViewLoadUrl:_realDataArr[one] forView:View4];
                
            }
        
        View0 = nil;
        View1 = nil;
        View2 = nil;
        View3 = nil;
        View4 = nil;
        
        }
    
    View = nil;

}
//归零
-(void)getZeroWithView:(UIView *)View{
    
    //滚动到首位
    [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
    
    if (_realDataArr.count > 0) {
        
        [self webViewLoadUrl:_realDataArr[0] forView:View];
    }

    _orientationIndex = 0;
}
//获得当前位置
-(int)getCurrentPosition{
    
    return floor((self.contentOffset.x - _contentRect.width / 2) / _contentRect.width) + 1;
}
/*****************************创建数据源*********************************/

-(void)getAGroupData{
    
    if ([_delegateCard respondsToSelector:@selector(getRealData)]) {
        _realDataArr = [_delegateCard getRealData];
        if (_realDataArr) {
            [self dealWithData:CGRectMake(0, 0, _contentRect.width, _contentRect.height) andDataArr:_realDataArr];
        }
    }
}
-(void)dealWithData:(CGRect)frame andDataArr:(NSArray *)realDataArray{
    
    //计算轮数
    _orientationIndexTotal = realDataArray.count/3;
    //计算余数
    _remainderIndex =realDataArray.count%3;
    //计算真实轮数
    if (_remainderIndex>0) {
        _orientationIndexTotal++;
    }
    
    //根据真实的数据源确定使用哪一种模板
    if (realDataArray.count == 1) {
        _pageCount = 1;
    }else if (realDataArray.count == 2){
        _pageCount = 2;
    }else if (realDataArray.count >= 3){
        _pageCount = 3;
    }else{
        return ;
    }
    
    __block NSArray *dataArr;
    //        //确定底层的模版
    [self initWithView:frame andContentCount:_pageCount andContentViewBlock:^(NSArray *content) {
        //拿到模板 自定义模板类型
        
        dataArr = [self creatNewContentViewWith:content];
        
    }];
    //获得模板源
    _plateDataArr = [[NSMutableArray alloc] initWithArray:dataArr];
    
    //暂时初始化的界面
    
    [self dynamicLoadingWithData:_plateDataArr andCurrentPage:[self getCurrentPosition]];
    
    dataArr = nil;

}
#pragma mark 决定轮播上面暂时的view类型
//创建内容模板类型
-(NSArray *)creatNewContentViewWith:(NSArray *)contentViewArr{
    
    /******模板类型****/
    UICardView_Cell * cell;
    //底板
    UIView *view;
    
    NSMutableArray * dataArr;
    
    dataArr= [[NSMutableArray alloc] init];
    
    switch (contentViewArr.count) {
        case 1:
            
            view = (UIView*)contentViewArr[0];
            cell = (UICardView_Cell*)[self singleViewWithSize:view.frame];
            [view addSubview:cell];
            //统筹
            [dataArr addObject:cell];
            
            break;
            
        case 4:
            
            for (int i = 0 ; i< 4 ; i ++ ) {
                
                view = (UIView*)contentViewArr[i];
                cell = (UICardView_Cell*)[self singleViewWithSize:view.frame];
                [view addSubview:cell];
                //统筹
                [dataArr addObject:cell];

            }
            
            break;
            
        case 5:
            
            for (int i = 0 ; i< 5 ; i ++ ) {
                view = (UIView*)contentViewArr[i];
                cell = (UICardView_Cell*)[self singleViewWithSize:view.frame];
                [view addSubview:cell];
                //统筹
                [dataArr addObject:cell];
            }
            
            break;
        default:
            break;
    }
    
    cell = nil;
    view = nil;
    
    return dataArr;
    
    
}
//创建view
-(UIView *)singleViewWithSize:(CGRect)rect{
    UIView *view;
    
    if (nil == view) {
        view = (UIView *)[[NSClassFromString(ClassTemplateView) alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        if (view == nil) {
            return nil;
        }
    }
    
    return view;
}
//加载具体地址
-(void)webViewLoadUrl:(NSString *)strUrl forView:(UIView *)View{
    
    UICardView_Cell *cellView;
    
    cellView = (UICardView_Cell *)View;
    
    /***这边确定自定义界面的样式内容****/
    
    cellView.label.text = strUrl;
    
}

@end
