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
#import "UUScoreListViewController.h"//积分列表

#define KHeaderHeight ((260 * Iphone6ScaleWidth) + kStatusBarHeight)

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,headerViewDelegate,XYTransitionProtocol,CLLocationManagerDelegate,PKPaymentAuthorizationViewControllerDelegate,UITextFieldDelegate>
{
    UILabel * lbl;

    MineHeaderView *_headerView;//头部view
    UIView *_NavView;//导航栏
    UITextField *_field;
    
}
@property (nonatomic, strong) CLLocationManager *locationManagerReplace;
@property (nonatomic, strong) NSMutableArray    *scoreArr;;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

//    self.StatusBarStyle = UIStatusBarStyleLightContent;
//    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    NSMutableArray *itemArr = [NSMutableArray new];
   
    LMJWordItem *myWalletItem = [LMJWordItem itemWithTitle:@"我的积分" subTitle:@"0" itemOperation:^(NSIndexPath *indexPath) {
        //点击进入积分明细
        if (_scoreArr.count > 0) {
            UUScoreListViewController *scoreList = [UUScoreListViewController new];
            scoreList.scoreData = _scoreArr;
            [self.navigationController pushViewController:scoreList animated:YES];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"您还没有积分记录" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        }
    }];
    
    LMJWordItem *myPositionItem = [LMJWordItem itemWithTitle:@"我的位置" subTitle:@"100" itemOperation:^(NSIndexPath *indexPath) {
         [self startLocationReplace];
    }];
    
    LMJWordItem *myWXPayItem = [LMJWordItem itemWithTitle:@"微信支付" subTitle:@"0.01" itemOperation:^(NSIndexPath *indexPath) {
        [WXApiRequestHandler jumpToBizPay];
    }];
    LMJWordItem *applePayItem = [LMJWordItem itemWithTitle:@"ApplePay" subTitle:@"0.01" itemOperation:^(NSIndexPath *indexPath) {
        [self ApplePay];
    }];
    
    LMJWordItem *zhengzeItem = [LMJWordItem itemWithTitle:@"是电话号码？" subTitle:@"点击" itemOperation:^(NSIndexPath *indexPath) {
        
        LMJItemSection *section = self.sections[0];
        
        LMJWordItem *myPosition = section.items[4];
        if (_field.text.length == 0 || _field == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"请输入手机号码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
            _field.text = @"";
            return;
        }
        myPosition.subTitle = ([ToolHelper validateMobile:_field.text] || [ToolHelper validatePhone:_field.text] || [ToolHelper validatePhoneNone:_field.text]) ? @"是" : @"否";
        _field.text = @"";
        
        [self.tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [itemArr addObjectsFromArray:@[myWalletItem,myPositionItem,myWXPayItem,applePayItem,zhengzeItem]];
    [self.sections addObject:[LMJItemSection sectionWithItems:itemArr andHeaderTitle:nil footerTitle:nil]];
    [self.tableView reloadData];
    UIBarButtonItem *rightConfigItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(changeUser)];
    self.navigationItem.rightBarButtonItem = rightConfigItem;
    [self createUI];
}

//获取积分
- (void)getScore:(void(^)(NSString *scoreStr))scoreBlock{
    NSString *scoreUrl = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"VipPointsList/%@/%@",[defaults objectForKey:KCompanyCode],[defaults objectForKey:KUserData][@"Id"]]];
    _scoreArr = [NSMutableArray new];
    uWeakSelf
    [[HttpRequest getInstance] postWithURLString:scoreUrl headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSString *compStr = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        NSData *data = [compStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *compArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",compArr);
        weakSelf.scoreArr = compArr.mutableCopy;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options: error:nil];
        scoreBlock(compArr.count > 0 ? [compArr[0][@"积分余额"] stringValue]:@"0");
    } failure:^(NSError *error, NSURLSessionTask *task) {
        
    }];
}

- (void)createUI {
    self.tableView.height = KScreenHeight - kTabBarHeight;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, -KHeaderHeight, KScreenWidth, KHeaderHeight)];
    _headerView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(_headerView.height, 0, 0, 0);
    [self.tableView addSubview:_headerView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取用户数据
    [self getRequset];
     //获取会员积分
    [self getScore:^(NSString *scoreStr) {
        LMJItemSection *section = self.sections[0];
        LMJWordItem *myPosition = section.items[0];
        myPosition.subTitle = scoreStr;
        [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    self.navigationController.delegate = self.navigationController;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:COLOR_BLUE] forBarMetrics:UIBarMetricsDefault];
    //    [self ysl_removeTransitionDelegate];
}

#pragma mark ————— 拉取数据 —————
-(void)getRequset{
    NSDictionary *dict = [defaults objectForKey:KUserData];
    UserInfo *info = [UserInfo initData:dict];
    _headerView.userInfo = info;
}

#pragma mark ————— 头像被点击 —————
-(void)headerViewClick{
    //    [self ysl_addTransitionDelegate:self];
//    ProfileViewController *profileVC = [ProfileViewController new];
//    profileVC.headerImage = _headerView.headImgView.image;
//    [self.navigationController pushViewController:profileVC animated:YES];
    [UIAlertController mj_showAlertWithTitle:@"点击头像" message:@"正在开发中..." appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDefaultTitle(@"确认");
        
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

#pragma mark ————— 昵称被点击 —————
-(void)nickNameViewClick{
    [self.navigationController pushViewController:[RootViewController new] animated:YES];
}

#pragma mark -- YSLTransitionAnimatorDataSource

-(UIView *)targetTransitionView{
    return _headerView.headImgView;
}
-(BOOL)isNeedTransition{
    return YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4 ) {
        if (_field == nil) {
            _field = [[UITextField alloc]initWithFrame:CGRectMake(KScreenWidth * 0.3, 0, KScreenWidth * 0.5, cell.height)];
        }
        _field.placeholder = @"请输入手机号码";
        _field.delegate = self;
        _field.keyboardType = UIKeyboardTypeNumberPad;
        _field.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:_field];
        
    }
   

    return cell;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    LMJItemSection *section = self.sections[0];
    LMJWordItem *myPosition = section.items[4];
    myPosition.subTitle = @"点击";
     [self.tableView reloadRow:4 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    
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
            LMJItemSection *section = self.sections[0];
            
            LMJWordItem *myPosition = section.items[1];
            myPosition.subTitle = city;
            [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
            
            
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
