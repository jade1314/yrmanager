//
//  MineViewController.m
//  MiAiApp
//
//  Created by JadeM on 2017/5/18.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineHeaderView.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "XYTransitionProtocol.h"
#import <CoreLocation/CoreLocation.h>
#import "WXApiRequestHandler.h"

#define KHeaderHeight ((260 * Iphone6ScaleWidth) + kStatusBarHeight)

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,headerViewDelegate,XYTransitionProtocol,CLLocationManagerDelegate,PKPaymentAuthorizationViewControllerDelegate>
{
    UILabel * lbl;
    NSArray *_dataSource;
    MineHeaderView *_headerView;//头部view
    UIView *_NavView;//导航栏
}
@property (nonatomic, strong) CLLocationManager *locationManagerReplace;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequset];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    self.navigationController.delegate = self.navigationController;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self ysl_removeTransitionDelegate];
}

#pragma mark ————— 拉取数据 —————
-(void)getRequset{
    _headerView.userInfo = curUser;
}

#pragma mark ————— 头像被点击 —————
-(void)headerViewClick{
    //    [self ysl_addTransitionDelegate:self];
    ProfileViewController *profileVC = [ProfileViewController new];
    profileVC.headerImage = _headerView.headImgView.image;
    [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark ————— 昵称被点击 —————
-(void)nickNameViewClick{
    [self.navigationController pushViewController:[RootViewController new] animated:YES];
}

#pragma mark -- YSLTransitionAnimatorDataSource
//-(UIImageView *)pushTransitionImageView{
//    return _headerView.headImgView;
//}
//
//- (UIImageView *)popTransitionImageView
//{
//    return nil;
//}
-(UIView *)targetTransitionView{
    return _headerView.headImgView;
}
-(BOOL)isNeedTransition{
    return YES;
}


#pragma mark ————— 创建页面 —————
-(void)createUI{
    self.tableView.height = KScreenHeight - kTabBarHeight;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, -KHeaderHeight, KScreenWidth, KHeaderHeight)];
    _headerView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(_headerView.height, 0, 0, 0);
    [self.tableView addSubview:_headerView];
    
    
    [self.view addSubview:self.tableView];
    
    [self createNav];
    
    NSDictionary *myWallet = @{@"titleText":@"我的钱包",@"clickSelector":@"",@"title_icon":@"qianb",@"detailText":@"10.00",@"arrow_icon":@"arrow_icon"};
    NSDictionary *myMission = @{@"titleText":@"我的任务",@"clickSelector":@"",@"title_icon":@"renw",@"arrow_icon":@"arrow_icon"};
    NSDictionary *myFriends = @{@"titleText":@"我的好友",@"clickSelector":@"",@"title_icon":@"haoy",@"arrow_icon":@"arrow_icon"};
    NSDictionary *myLevel = @{@"titleText":@"我的等级",@"clickSelector":@"",@"title_icon":@"dengji",@"detailText":@"LV10",@"arrow_icon":@"arrow_icon"};
    
    NSDictionary *myPosition = @{@"titleText":@"我的位置",@"clickSelector":@"",@"title_icon":@"dengji",@"detailText":@"中国",@"arrow_icon":@"arrow_icon"};
    
    NSDictionary *myWXPay = @{@"titleText":@"WXPay",@"clickSelector":@"",@"title_icon":@"dengji",@"detailText":@"myWXPay",@"arrow_icon":@"arrow_icon"};
    NSDictionary *applePay = @{@"titleText":@"applePay",@"clickSelector":@"",@"title_icon":@"dengji",@"detailText":@"applePay",@"arrow_icon":@"arrow_icon"};
    
    _dataSource = @[myWallet,myMission,myFriends,myLevel,myPosition,myWXPay,applePay];
    [self.tableView reloadData];
}
#pragma mark ————— 创建自定义导航栏 —————
-(void)createNav{
    _NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTopHeight)];
    _NavView.backgroundColor = KClearColor;
    
    UILabel * titlelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, KScreenWidth/2, kNavBarHeight )];
    titlelbl.centerX = _NavView.width/2;
    titlelbl.textAlignment = NSTextAlignmentCenter;
    titlelbl.font= SYSTEMFONT(17);
    titlelbl.textColor = KWhiteColor;
    titlelbl.text = self.title;
    [_NavView addSubview:titlelbl];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    btn.titleLabel.font = SYSTEMFONT(16);
    [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(_NavView.width - btn.width - 15, kStatusBarHeight, btn.width, 40);
    [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeUser) forControlEvents:UIControlEventTouchUpInside];
    
    [_NavView addSubview:btn];
    
    [self.view addSubview:_NavView];
}

#pragma mark ————— tableview 代理 —————
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell" forIndexPath:indexPath];
    cell.cellData = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            NSLog(@"点击了 我的钱包");
            break;
        case 1:
            NSLog(@"点击了 我的任务");
            break;
        case 2:
            NSLog(@"点击了 我的好友");
            break;
        case 3:
            NSLog(@"点击了 我的等级");
            break;
        case 4:
        {
            NSLog(@"点击了 我的位置");
            [self startLocationReplace];
        }
            break;
        case 5:
        {
            NSLog(@"点击了 WXPay");
             [WXApiRequestHandler jumpToBizPay];
        }
            break;
        case 6:
        {
            NSLog(@"点击了 ApplePay");
            [self ApplePay];
        }
            break;
        default:
            break;
    }
}



- (void)ApplePay {
    PKPaymentRequest *request = [WXApiRequestHandler jumpToApplePay:self];
    
    PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    if (paymentPane == nil) {
        NSLog(@"授权控制器创建失败");
    }
    if ([request isKindOfClass:[NSString class]]) {
        NSLog(@"返回格式有误");
        return;
    }
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:YES completion:nil];
    //    if( ![@"" isEqual:res] ){
    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //        [alter show];
    //        [alter release];
    //    }
    
}
//applePay代理方法
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    NSLog(@"取消或者交易完成");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ————— scrollView 代理 —————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y ;
    CGFloat totalOffsetY = scrollView.contentInset.top + offset;
    
    NSLog(@"offset    %.f   totalOffsetY %.f",offset,totalOffsetY);
    //    if (totalOffsetY < 0) {
    _headerView.frame = CGRectMake(0, offset, self.view.width, KHeaderHeight- totalOffsetY);
    //    }
    
}

#pragma mark ————— 切换账号 —————
-(void)changeUser{
    SettingViewController *settingVC = [SettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 定位
////开始定位
- (void)startLocationReplace {
    if ([CLLocationManager locationServicesEnabled]) {
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
            MineTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            
            cell.cellData = @{@"titleText":@"我的位置",@"clickSelector":@"",@"title_icon":@"dengji",@"detailText":[NSString stringWithFormat:@"%@",city],@"arrow_icon":@"arrow_icon"};
            
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

@end
