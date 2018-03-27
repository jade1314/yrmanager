//
//  LMJElementsCollectionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/19.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJElementsCollectionViewController.h"
#import <HMScannerController.h>
#import <CoreLocation/CoreLocation.h>
#import "UUSempleCollectionViewCell.h"

@interface LMJElementsCollectionViewController ()<LMJElementsFlowLayoutDelegate,CLLocationManagerDelegate>{
    
    UIButton *_loctionBtn;//定位按钮
    UIButton *_qrcBtn;//二维码扫描
    UIButton *_moreBtn;//更多
    
}
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHightSecond;
@property (nonatomic, strong) CLLocationManager *locationManagerReplace;

@end

@implementation LMJElementsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    [self.collectionView registerClass:[UUSempleCollectionViewCell class] forCellWithReuseIdentifier:@"UUSempleCollectionViewCell"];
    
    [self initButton:self.collectionView];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UUSempleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UUSempleCollectionViewCell class]) forIndexPath:indexPath];
    cell.dataDict = @{@"image":@"trade_fund1",@"title":@"北京"};
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    NSLog(@"%zd", indexPath.item);
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.elementsHightSecond.count;
    }else{
        return self.elementsHight.count;
    }
}

- (CGSize)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.elementsHightSecond[indexPath.item].CGSizeValue;
    }
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView{
   
    return UIEdgeInsetsMake(0, 10, 10, 10);
    
}

- (CGFloat)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)waterflowLayout:(LMJElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.1;
    }
    return 10;
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    LMJElementsFlowLayout *elementsFlowLayout = [[LMJElementsFlowLayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [leftButton setTitle:@"< 返回" forState:UIControlStateNormal];
    
    leftButton.lmj_width = 60;
    
    [leftButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}
/** 导航条右边的按钮 */
- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [rightButton setTitle:@"改变头图高度" forState:UIControlStateNormal];
    
    rightButton.lmj_width = 120;
    
    [rightButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
    
    return nil;
}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
//    [self.elementsHight replaceObjectAtIndex:0 withObject:[NSValue valueWithCGSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 30) * 0.5, 44)]];
//
//    [self.collectionView reloadData];
}


- (NSMutableArray<NSValue *> *)elementsHight{
    if(_elementsHight == nil){
        _elementsHight = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
            [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake((kScreenWidth - 40)/3, (kScreenWidth - 40)/3)]];
        }
    }
    return _elementsHight;
}

- (NSMutableArray<NSValue *> *)elementsHightSecond {
    if(_elementsHightSecond == nil){
        _elementsHightSecond = [NSMutableArray array];
        [_elementsHightSecond addObject:[NSValue valueWithCGSize:CGSizeMake(kScreenWidth, 100)]];
    }
    return _elementsHightSecond;
}

- (void) initButton:(UIView *)cellBackView {//
    _loctionBtn = [self btnWithFrame:CGRectMake(0, 40, KScreenWidth/3, 30) imageName:@"hangqing" selector:@selector(startLocationReplace)];
    _loctionBtn.tag = 101;
    [cellBackView addSubview:_loctionBtn];
    
    _qrcBtn = [self btnWithFrame:CGRectMake(KScreenWidth - 50, 40, 50, 30) imageName:@"closeblue" selector:@selector(qrCodeBtnClicked)];
    [cellBackView addSubview:_qrcBtn];
    
    _moreBtn = [self btnWithFrame:CGRectMake(KScreenWidth - 100, 40, 50, 30) imageName:@"search" selector:@selector(moreBtnClicked)];
    [cellBackView addSubview:_moreBtn];
    
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
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:[defaults objectForKey:KUserData][@"id"] avatar:nil completion:^(NSString *stringValue) {
        
        NSString * url = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",stringValue];//把http://带上
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    [self showDetailViewController:scanner sender:nil];
}

- (void) moreBtnClicked {
    
}


@end
