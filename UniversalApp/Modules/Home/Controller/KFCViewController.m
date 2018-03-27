//
//  KFCViewController.m
//  UniversalApp
//
//  Created by 王玉 on 2018/3/19.
//  Copyright © 2018年 JadeM. All rights reserved.
//

#import "KFCViewController.h"

#import "LMJElementsCollectionViewController.h"

@interface KFCViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_backView;
    UIImageView *_topImageView;
    UIScrollView *_bottomScrollView;
    LMJElementsCollectionViewController *_bottomCollectionView;//下面视图
}

@end

@implementation KFCViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self initBackView];
    self.navigationController.navigationBar.hidden = YES;
}
//初始化backView
- (void) initBackView {
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _backView.pagingEnabled = YES;
    _backView.delegate = self;
    _backView.showsVerticalScrollIndicator = NO;
    _backView.showsHorizontalScrollIndicator = NO;
    _backView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * 2);
    _backView.contentOffset = CGPointMake(0, KScreenHeight);
    [self.view addSubview:_backView];
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _topImageView.image = [UIImage imageNamed:@"10001.png"];
    [_backView addSubview:_topImageView];
    
    
    _bottomCollectionView = [LMJElementsCollectionViewController new];
    [self addChildViewController:_bottomCollectionView];
    _bottomCollectionView.view.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
    [_backView addSubview:_bottomCollectionView.view];
//    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
//    _bottomScrollView.pagingEnabled = NO;
//    _bottomScrollView.userInteractionEnabled = YES;
//    _bottomScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * 2);
//    _bottomScrollView.contentOffset = CGPointMake(0, 0);
//    _bottomScrollView.showsVerticalScrollIndicator = NO;
//    _bottomScrollView.showsHorizontalScrollIndicator = NO;
//    _bottomScrollView.backgroundColor = COLOR_YELLOW;
//    [_backView addSubview:_bottomScrollView];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 44 + 1) {
        [AppDelegate shareAppDelegate].mainTabBar.tabBar.hidden = YES;
    } else {
        [AppDelegate shareAppDelegate].mainTabBar.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
