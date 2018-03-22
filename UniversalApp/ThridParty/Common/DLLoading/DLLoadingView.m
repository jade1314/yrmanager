//
//  TKLoadingView.m
//  MobileSchool
//
//  Created by songs on 14/11/12.
//  Copyright (c) 2014年 feng zhanbo. All rights reserved.
//

#import "DLLoadingView.h"
#import "LLARingSpinnerView.h"
#import "DLLoading.h"

#define VIEW_SX_GAP                         18              //上下间隔
#define VIEW_ZY_GAP                         20              //左右间隔
#define TITLE_GAP                           10              //文字与加载框间隔

#define CLOSE_BUTTON_OUTSIDE_GAP            5               //关闭按钮中心点与边框间隔

@interface DLLoadingView()
{
    UIView *_bgView;
    UIView *_contentView;
    UIView *_cirBgView;
    UILabel *_titleLabel;
    UIButton *_closeButton;
    
    LLARingSpinnerView *_loading;
}

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) DLCloseLoadingView closeBlock;

@end

@implementation DLLoadingView

-(void)dealloc
{
    [self stopLoadingAnimating];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
//        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
//								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _bgView = [UIView new];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [_bgView setAlpha:0];
        [self addSubview:_bgView];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _cirBgView = [UIView new];
        [_contentView addSubview:_cirBgView];
        _cirBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_cirBgView.layer setCornerRadius:5];
        
        _loading = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
        _loading.bounds = CGRectMake(0, 0, 40, 40);
        _loading.circleColor = [UIColor whiteColor];//[DLLoading colorWithHexString:@"#0099FF"];
        _loading.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [_contentView addSubview:_loading];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closeButton setFrame:CGRectMake(0, 0, 40, 40)];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_closeButton];
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        [_contentView addSubview:_titleLabel];
    }
    
    return self;
}

-(void)showTitleLabel:(NSString*)title
{
    if (title) {
        CGFloat closeGap = _closeButton.frame.size.width/2-CLOSE_BUTTON_OUTSIDE_GAP;
        [_titleLabel setFrame:CGRectMake(0, 0, MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)-VIEW_ZY_GAP*4-closeGap*2, CGFLOAT_MIN)];
        [_titleLabel setText:title];
        [_titleLabel sizeToFit];
    }
}

-(void)showLoading:(NSString*)title
{
    CGFloat closeGap = 0;
    if (self.closeBlock) {
        closeGap = _closeButton.frame.size.width/2-CLOSE_BUTTON_OUTSIDE_GAP;
    }
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (title) {
        [self showTitleLabel:title];
        width = MAX(_titleLabel.frame.size.width, _loading.frame.size.width)+VIEW_ZY_GAP*2 + closeGap*2;
        height = _loading.frame.size.height + _titleLabel.frame.size.height + VIEW_SX_GAP*2 + TITLE_GAP + closeGap*2;
    }else{
        width = _loading.frame.size.width+VIEW_ZY_GAP*2+closeGap*2;
        height = _loading.frame.size.height+VIEW_SX_GAP*2+closeGap*2;
    }
    
    [_contentView setFrame:CGRectMake(0, 0, width, height)];
    [_contentView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_cirBgView setFrame:CGRectMake(0, 0, width-closeGap*2, height-closeGap*2)];
    [_cirBgView setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    [_loading setCenter:CGPointMake(_contentView.frame.size.width/2, _loading.frame.size.height/2+VIEW_SX_GAP+closeGap)];
    
    if (title) {
        [_titleLabel setCenter:CGPointMake(_loading.center.x, CGRectGetMaxY(_loading.frame)+TITLE_GAP+_titleLabel.frame.size.height/2)];
    }
    
    if (self.closeBlock) {
        [_closeButton setCenter:CGPointMake(_contentView.frame.size.width-_closeButton.frame.size.width/2, _closeButton.frame.size.height/2)];
    }
}

-(void)close
{
    if (self.closeBlock) {
        self.closeBlock();
    }
    
    [UIView animateWithDuration:.3 animations:^{
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
        [_contentView setAlpha:0];
        [_bgView setAlpha:0];
    } completion:^(BOOL s){
        [self removeFromSuperview];
        [_contentView setAlpha:1];
        _contentView.transform = CGAffineTransformIdentity;
        [self stopLoadingAnimating];
        
        [self unregisterFromNotifications];
        self.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 公共方法
-(void)showToolTip:(NSString*)title interval:(NSTimeInterval)time inView:(UIView *)view
{
    BOOL isHave = [self isHaveDLLoadingView:view];
    [_titleLabel setHidden:title?NO:YES];
    [_bgView setHidden:YES];
    [_loading setHidden:YES];
    [_closeButton setHidden:YES];
    [self stopLoadingAnimating];
    
    [self showTitleLabel:title];
    
    [_contentView setFrame:CGRectMake(0, 0, _titleLabel.frame.size.width+2*VIEW_ZY_GAP, _titleLabel.frame.size.height+2*VIEW_SX_GAP)];
    [_contentView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    [_cirBgView setFrame:_contentView.bounds];
    [_cirBgView setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    [_titleLabel setCenter:CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2)];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:time];
    
    [_bgView setAlpha:0];
    if (!isHave) {
        [self startViewAnimating];
    }
    
    [self changeShowStyle:YES];
}

-(void)showLoading:(NSString*)title close:(DLCloseLoadingView)close inView:(UIView *)view
{
    BOOL isHave = [self isHaveDLLoadingView:view];
    [_titleLabel setHidden:title?NO:YES];
    [_bgView setHidden:NO];
    [_loading setHidden:NO];
    [_closeButton setHidden:close?NO:YES];
    
    self.closeBlock = close;
    [self showLoading:title];
    
    if (isHave) {
        [_bgView setAlpha:.3];
    }else{
        [self startViewAnimating];
    }
    [self startLoadingAnimating];
    
    [self changeShowStyle:NO];
}

#pragma mark - 私有方法
//改变显示样式，tip是否属于提示信息
-(void)changeShowStyle:(BOOL)tip
{
    UIColor *titleColor = nil;
    UIColor *contentColor = nil;
    CGFloat alpha = 0;
    if (tip) {
        titleColor = [DLLoading colorWithHexString:@"#f8f8f8"];
        contentColor = [UIColor blackColor];
        alpha = 0.6;
    }else{
        titleColor = [UIColor whiteColor];//[DLLoading colorWithHexString:@"#0099ff"];
        contentColor = [UIColor blackColor];//[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        _cirBgView.alpha = 0.5;
        alpha = 1;
    }
    
    [_cirBgView setBackgroundColor:contentColor];
    [_cirBgView setAlpha:alpha];
    _titleLabel.textColor = titleColor;
}

-(BOOL)isHaveDLLoadingView:(UIView*)view
{
    __block BOOL isHave = NO;
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:self]) {
            isHave = YES;
            *stop = YES;
        }
    }];
    
    if (!isHave) {
        [view addSubview:self];
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self registerForNotifications];
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.left.right.equalTo(0);
//        }];
        [self setTransformForCurrentOrientation];
    }
    
    return isHave;
}

#pragma mark - 动画效果
-(void)startViewAnimating
{
    [_loading startAnimating];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView animateWithDuration:.3 animations:^{
        [_bgView setAlpha:.3];
        _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
}

#pragma mark - 定时器
-(void)startLoadingAnimating
{
    [_loading startAnimating];
}

-(void)stopLoadingAnimating
{
    [_loading stopAnimating];
}

#pragma mark - Notifications

- (void)registerForNotifications
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationDidChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
}

- (void)unregisterFromNotifications
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidChangeStatusBarOrientationNotification
                                                      object:nil];
    }
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification
{
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else{
        [self setTransformForCurrentOrientation];
    }
}

- (void)setTransformForCurrentOrientation
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        return;
    }
    
    if (self.superview) {
        self.bounds = self.superview.bounds;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            radians = -(CGFloat)M_PI_2;
        }else {
            radians = (CGFloat)M_PI_2;
        }
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            radians = (CGFloat)M_PI;
        }else {
            radians = 0;
        }
    }
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
    [self setTransform:rotationTransform];
}

@end
