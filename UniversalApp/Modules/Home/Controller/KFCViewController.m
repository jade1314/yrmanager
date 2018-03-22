//
//  KFCViewController.m
//  UniversalApp
//
//  Created by 王玉 on 2018/3/19.
//  Copyright © 2018年 JadeM. All rights reserved.
//

#import "KFCViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface KFCViewController ()<CLLocationManagerDelegate,UIScrollViewDelegate>
{
    UIScrollView *_backView;
    UIImageView *_topImageView;
    UIScrollView *_bottomScrollView;
    UIButton *_loctionBtn;//定位按钮
    UIButton *_qrcBtn;//二维码扫描
    UIButton *_moreBtn;//更多
}

@property (nonatomic, strong) CLLocationManager *locationManagerReplace;
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
    //定位 二维码 更多
    [self initButton];
    // Do any additional setup after loading the view from its nib.
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
    
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _bottomScrollView.pagingEnabled = NO;
    _bottomScrollView.userInteractionEnabled = YES;
    _bottomScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * 2);
    _bottomScrollView.contentOffset = CGPointMake(0, 0);
    _bottomScrollView.showsVerticalScrollIndicator = NO;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.backgroundColor = COLOR_YELLOW;
    [_backView addSubview:_bottomScrollView];
    
}

- (void) initButton {//
    _loctionBtn = [self btnWithFrame:CGRectMake(0, 40, KScreenWidth/3, 30) imageName:@"hangqing" selector:@selector(startLocationReplace)];
    [_bottomScrollView addSubview:_loctionBtn];
    
    _qrcBtn = [self btnWithFrame:CGRectMake(KScreenWidth - 50, 40, 50, 30) imageName:@"closeblue" selector:@selector(qrCodeBtnClicked)];
    [_bottomScrollView addSubview:_qrcBtn];
    
    _moreBtn = [self btnWithFrame:CGRectMake(KScreenWidth - 100, 40, 50, 30) imageName:@"search" selector:@selector(moreBtnClicked)];
    [_bottomScrollView addSubview:_moreBtn];
    
}

- (UIButton *)btnWithFrame:(CGRect)rect imageName:(NSString *)name selector:(SEL)sel {
    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark -- 定位
////开始定位
- (void) startLocationReplace {
    if ([CLLocationManager locationServicesEnabled] && ![_loctionBtn.titleLabel.text isEqualToString:@"正在定位..."]) {
        //        CLog(@"--------开始定位");
        self.locationManagerReplace = [[CLLocationManager alloc]init];
        self.locationManagerReplace.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManagerReplace.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManagerReplace requestAlwaysAuthorization];
        self.locationManagerReplace.distanceFilter = 10.0f;
        [self.locationManagerReplace requestAlwaysAuthorization];
        [self.locationManagerReplace startUpdatingLocation];
    }else{
        NSLog(@"打开地域选择菜单");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);//石家庄市
            NSLog(@"--%@",placemark.name);//黄河大道221号
            NSLog(@"++++%@",placemark.subLocality); //裕华区
            NSLog(@"country == %@",placemark.country);//中国
            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
            
            [_loctionBtn setTitle:kString_Format(@"%@",city) forState:UIControlStateNormal];
            
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}


- (void) qrCodeBtnClicked {
    
}

- (void) moreBtnClicked {
    
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
