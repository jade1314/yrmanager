//
//  UICarouselView.m
//  PanGu
//  轮播图控件
//  Created by jade on 16/6/27.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UICarouselView.h"
#import "UIImageView+WebCache.h"
//默认图  暂时用这张
#define placeHolderImage @"add@3x.png"

@interface UICarouselView()
{
    CGRect viewSize;//大小
    UIScrollView *scrollView;//底部控件
    NSArray *imageArray;//数据源
    UIPageControl *pageControl;//标记控件
    int currentPageIndex;//当前标记
    NSInteger _pageCount;//真实的轮播页数量
    //计时器
    NSTimer *_moveTimer;
    
}

//异常情况
@property (nonatomic, strong)NSMutableArray *failarray;

@end
@implementation UICarouselView

#pragma mark －－懒加载
-(NSMutableArray *)failarray{
    if (_failarray == nil) {
        _failarray = [[NSMutableArray alloc] init];
    }
    return _failarray;
}

#pragma mark －－ 初始化
-(id)initWithFrameRect:(CGRect)rect withData:(NSArray *)dataArr
{
    self = [super initWithFrame:rect];
    //记录尺寸
    viewSize = rect;
    
    if (self) {
        //分析数据
        [self dealWithData:dataArr];
        //创建内容视图
        [self creatContentView:imageArray];
        
        //添加创建好的轮播器
        [self addSubview:scrollView];
        
        // 添加标记 和 计时器
        if ([dataArr count] > 1) {
            
            [self creatPageControlWithSuperView:scrollView andCount:_pageCount];
            
            [self creatTimer];
        }
        
    }
    return self;
}
-(void)creatContentView:(NSArray *)dataArr{
    
    //创建内容模板
    
    UIImageView *imgView;
    NSString *imgURL;
    NSURL *imageUrl;
    UIImage *img;
    
    for (int i=0; i<_pageCount; i++) {
        //实例化
        imgURL=[dataArr objectAtIndex:i];
        imageUrl = [NSURL URLWithString:imgURL];
        //创建合适数量的图片背板
        imgView=[[UIImageView alloc] init];
        
        imgView.tag = 1000 + i;
        
        if ([imgURL hasPrefix:@"http://"]||[imgURL hasPrefix:@"https://"]) {
            //网络图片 请使用ego异步图片库
            //加载图片
            [imgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:placeHolderImage] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    NSLog(@"下载失败%@",error);
                    [self.failarray addObject:[NSString stringWithFormat:@"%d", i]];
                }
            }];
        }
        else
        {
            //加载本地图片
            img=[UIImage imageNamed:[dataArr objectAtIndex:i]];
            [imgView setImage:img];
        }
        
        [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
        
        if(_pageCount >1){
            
            imgView.tag=i; // 多张图片处理
            
        }
        
        //添加手势
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        //创建的内容添加到scrollView上面
        [scrollView addSubview:imgView];
    }
    
    //对失败的图片重新加载
    if (_failarray.count > 0) {
        for (int i=0; i<_pageCount; i++) {
            imgURL = [dataArr objectAtIndex:i];
            imageUrl = [NSURL URLWithString:imgURL];
            for (int j = 0; j < _failarray.count; j++) {
                if ([[_failarray objectAtIndex:j] integerValue] == i) {
                    imgView = (UIImageView *)[scrollView viewWithTag:1000 + j];
                    if ([imgURL hasPrefix:@"http://"]||[imgURL hasPrefix:@"https://"]) {
                        //网络图片 请使用ego异步图片库
                        [imgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:placeHolderImage] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            NSLog(@"尽力了");
                        }];
                        
                    }
                }
            }
        }
    }
}
//数据分析
-(void)dealWithData:(NSArray *)dataArr{
    
    //空值处理
    if (dataArr ==nil || dataArr ==NULL) {
        return ;
    }
    
    if ([dataArr count] <= 0) {//特殊情况 特殊处理 处理没有数据来源的情况
        
        UIButton *imgBtn;
        //创建滚动
        scrollView = [self scrollViewInitWith:viewSize andCount:_pageCount];
        imgBtn = [[UIButton alloc] initWithFrame:scrollView.bounds];
        [imgBtn setImage:[UIImage imageNamed:placeHolderImage] forState:UIControlStateNormal];
        [imgBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:imgBtn];
        [self addSubview:scrollView];
        
        return ;//结束一切动作
        
    }else if([dataArr count] ==1){ //只有1张图片
         //将数据给imageArray
        imageArray=[NSArray arrayWithArray:dataArr];
        //记录数量
        _pageCount = [imageArray count];
        
    }else if([dataArr count] >1){ //大于1张图片
        
        NSMutableArray *tempArray;
        tempArray=[NSMutableArray arrayWithArray:dataArr];
        //处理数据源，前后分别插一张
        [tempArray insertObject:[dataArr objectAtIndex:([dataArr count]-1)] atIndex:0];
        [tempArray addObject:[dataArr objectAtIndex:0]];
        
        //将处理好的数据给imageArray
        imageArray=[NSArray arrayWithArray:tempArray];
        //记录数量
        _pageCount = [imageArray count];
        
    }
    //根据数据创建滚动
    scrollView = [self scrollViewInitWith:viewSize andCount:_pageCount];

}


#pragma mark -- 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    
    if (currentPageIndex < ([imageArray count])) {
        [UIView animateWithDuration:0.4f animations:^{
            scrollView.contentOffset = CGPointMake(currentPageIndex * scrollView.frame.size.width, 0);
        }];
        currentPageIndex ++;
    }
    if (currentPageIndex==0) {
        
        [scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count])) {
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }
}

#pragma mark scrollView －－ 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    //改变 pageControl 的状态
    pageControl.currentPage=(page-1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    _scrollView = scrollView;
    if (currentPageIndex==0) {
        
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }

}

#pragma mark scrollView －－ 自定义手势
- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    
    if ([_delegate respondsToSelector:@selector(UICarouselViewDidClicked:)]) {
        [_delegate UICarouselViewDidClicked:sender.view.tag];
    }
    
}
#pragma mark scrollView －－ 没有内容响应层
- (void)imgBtnClick{
    
    NSLog(@"跳转到固定页面");
    
}
#pragma mark scrollView －－ 控件
//创建pageControl层
-(UIPageControl *)creatPageControlWithSuperView:(UIView *)superView andCount:(NSInteger)count{
    
    UIPageControl * UIPC;
    
    
    float pageControlWidth=(count-2)*10.0f+40.f;
    float pageControlHeight=20.0f;
    
    UIPC=[[UIPageControl alloc]initWithFrame:CGRectMake((superView.frame.size.width-pageControlWidth)/2.0,(superView.frame.size.height-pageControlHeight), pageControlWidth, pageControlHeight)];
    
    UIPC.currentPage=0;
    UIPC.numberOfPages=(count-2);//这个_pageCount里面包含了两个未展示跳转面
    
    [superView.superview addSubview:UIPC];
    
    pageControl = UIPC;
    
    return UIPC;
    
}

//开启计时器
-(void)creatTimer{
    
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    
    //开启一个消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_moveTimer forMode:NSRunLoopCommonModes];
}

//scrollView 的基本属性
-(UIScrollView *)scrollViewInitWith:(CGRect)rect andCount:(NSInteger)count{
    
    UIScrollView *SV;
    
    if (nil == scrollView) {
        SV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }else{
        SV.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
    SV.pagingEnabled = YES;
    SV.contentOffset = CGPointMake(rect.size.width, 0);
    SV.contentSize = CGSizeMake(rect.size.width * count, rect.size.height);
    SV.showsHorizontalScrollIndicator = NO;
    SV.showsVerticalScrollIndicator = NO;
    SV.scrollsToTop = NO;
    SV.delegate = self;
    
    return SV;
}

@end
