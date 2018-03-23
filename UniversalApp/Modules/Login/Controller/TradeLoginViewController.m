
//  TradeLoginViewController.m
//  PanGu
//
//  Created by Fll on 16/8/13.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "TradeLoginViewController.h"

#import "UIView+TYAlertView.h"
//#import "YCView.h"
#import "HttpRequest.h"
//#import "HQ_SetDataAgent.h"
#import "UsersModel.h"
//#import "HQ_QueryAgent.h"

//#import "ConfigKeyboard.h"

#import "OpenUDID.h"
//#import <CRHFramework/CRHMainViewController.h>
#import <sys/utsname.h>
#import "RegisterLoginViewController.h"
#import "TradeLoginStartViewController.h"
//#import "OptionalNewsModel.h"
//#import "ModifyTransactionPasswordViewController.h"
//#import "PanGu-Swift.h"
#import "GetIpHelper.h"

//#import "RiskLevelViewController.h"
//#import "RiskLevelResultViewController.h"
#import "ReplaceCell.h"
//#import "tdxMsgPushOper.h"

#define multiple  kScreenHeight/667 //倍数
#define multiple_w  kScreenWidth/375 //倍数
#define messageVerifyTime   @"120"
#define voiceVerifyTime     @"120"

@interface TradeLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isScect;
    NSString *identifyStr;//验证码
    
    UIImageView *rightImageView;//验证码图片
    BOOL res;
    CGFloat heightFree;//iphone4 上移输入框
    UIView *bottomFieldView;//底板
    UILabel *titleThreeLabel;//重新获取验证码
    NSString *IdentifyString;//请求返回的验证码内容
    NSInteger lengthNum;
    
    NSString *clickLogin;//客服热线  防止误触
    NSInteger clickReplaceNum;//保证只跳一次更换资金账号 防止误触
    
    NSString *OUTIP;
    
    BOOL isClose;//下拉列表的收缩状态
    UITableView *moreCodeTableView;//资金账号下拉列表
    NSMutableArray *accountArray;//存放所有的资金账号
    UIButton *rightArrowButton;
    BOOL    isFirst;
    
}

@property (nonatomic, strong) UIButton *certainButton;

@property (nonatomic, strong) TYAlertController *alertController;

@property (nonatomic, copy)NSString *selectStr;//密码

@property (nonatomic, copy)NSString *fundCode;//资金账号

@end

@implementation TradeLoginViewController

-(NSString *)fundCode{
    if ([ToolHelper isBlankString:_fundCode]) {
        UITextField *fundCodeField = [self.view viewWithTag:100300];
        _fundCode=fundCodeField.text;
    }
    return _fundCode;
}
//如果密码为空 重新获取一次
-(NSString *)selectStr{
    if ([ToolHelper isBlankString:_selectStr] ) {
       
        UITextField *te = [self.view viewWithTag:100301];
        _selectStr = te.text;
    }
    return _selectStr;
}

-(void)didClickOKbutton{
    NSLog(@"ok");
}
-(void)didClickHideButton{
    NSLog(@"hide");
}


#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = YES;
    OUTIP = @"";
    [GetIpHelper urlRequestOperation:^(NSString *str) {
        OUTIP = str;
    } failure:nil];
    
    self.title = @"交易登录";
    
    heightFree = 0;
    
    accountArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.certainButton];
    [self createTextFieldThree];
    [self createMoreCodeTableView];
    //拿到所有资金账号
    
    if (accountArray.count == 0) {
        rightArrowButton.hidden = YES;
    }
    
}


//收起键盘
-(void)hideKeyboard:(NSInteger)num{
    if (num == 0) {
        
        [self.view endEditing:YES];
    }else if(num == 1){
        
    }else if (num == 2){
        [self.view endEditing:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageWithColor:COLOR_BLUE] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //初始化数据
    clickReplaceNum = 0;
    clickLogin = @"0";
    
    [self hideKeyboard:0];
    
    //检测 APP 合法性, 配置加密键盘
    NSString *fundStr = @"";
    if (![ToolHelper isBlankString:fundStr]) {
        UITextField *fundCodeField = [self.view viewWithTag:100300];
        fundCodeField.text=fundStr;
        _fundCode=fundStr;
    }
    [self requestImagePhotoIdentify];//验证码图片
    
    [self whetherUnsafeLogin:^{
        [self getPlugincomponents];
    }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldLoginDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyboard:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (bottomFieldView.top == -60) {
        bottomFieldView.top = 30;
    }
}


#pragma mark 点击验证码图片刷新验证码
- (void)identifyImageClick:(UITapGestureRecognizer *)tap{
    [self requestImagePhotoIdentify];//验证码图片
}
#define BASEURL @"http://jerrysoft.com.cn:8008/service1.svc/"
#define XMHTTPADDRESS @"http://jerrysoft.com.cn:8008/service1.svc/LogInf/111/112"
#pragma mark 确定按钮
- (void)buttonTradeClick {
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:@"LogInf/111/111"] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",dict);
        KPostNotification(KNotificationLoginStateChange, @YES);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
}



#pragma mark 新增/修改 交易账号与手机号绑定接口
- (void)transactionAccountNumberPhoneNumberBinding:(NSString *)tokenString {
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    [parmDic setValue:@"1" forKey:@"type"];//绑定关系的账户类型 1：资金账户
    [parmDic setValue:self.fundCode forKey:@"account"];//绑定关系的账户号码
    [parmDic setValue:@"" forKey:@"user_type"];//账户号码类型 1：手机用户  2：QQ用户  3：微信用户  4：微博用户
    [parmDic setValue:@"" forKey:@"user_account"];//账户号码
    [params setValue:@"800104" forKey:@"funcid"];
    [params setValue:tokenString forKey:@"token"];
    [params setValue:parmDic forKey:@"parms"];
    
    [[HttpRequest getInstance] postWithURLString:@"" headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        
    }];
}

//跳转
-(void)transactionAccountToken:(NSString *)tokenString old_SRRC:(NSString *)srrc old_TCC:(NSString *)tcc isOverdue:(NSString *)isOverdue endDate:(NSString *)endDate riskLevel:(NSString *)riskLevel {
    
    
    
}






- (void)jumpControl {
    if ([_pushViewController isKindOfClass:[RegisterLoginViewController class]] ||
        [_pushViewController isKindOfClass:[TradeLoginStartViewController class]] ||
        [_pushViewController isKindOfClass:[TradeLoginViewController class]] ||
        _pushViewController == nil || _pushViewController == NULL) {
        
    }else {
        
        [self.navigationController pushViewController:_pushViewController animated:YES];
        
    }
}


#pragma mark 登录接口
- (void)requestLogin {
    
}

-(void)exitLoginStatus {
    [self exitControl];
    
    [self exitLogin];//交易登录退出接口
    
}

#pragma mark 交易登录退出接口
-(void)exitLogin {
    
}


- (void)exitControl {
    
}


// http 请求是否允许使用明文
- (void)whetherUnsafeLogin:(void(^)(void))getBlock {
    
}

#pragma mark Notice
- (void)textFieldLoginDidChange:(NSNotification *)notification {
    UITextField *textField = [notification object];
    
    if (textField.tag==100300) {
        if (textField.text.length==18){
            [self hideKeyboard:2];
        } else if (textField.text.length > 18) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 18)];
            [self hideKeyboard:2];
        }
        _fundCode=textField.text;
        
        if ([ToolHelper isBlankString:textField.text]) {
            [self clearTextFieldContent];
        }
        
    }else if (textField.tag==100301){
        _selectStr=textField.text;//明文时的密码
        if (_selectStr.length != 0) {
            BOOL resJust=[ToolHelper validateNumber:_selectStr];//8位数字
            if (resJust) {
                NSLog(@"数字");
            }else{
                [DLLoading DLToolTipInWindow:@"密码只能是数字"];
            }
        }
        if (_selectStr.length==8) {
            [self hideKeyboard:2];
        }
        
        
        if ([ToolHelper isBlankString:textField.text]) {
            [self clearTextFieldContent];
        }
        
        NSLog(@"密码 %@",_selectStr);
    }else if (textField.tag==100302){
        
        if (textField.text.length==4){
            [self hideKeyboard:2];
        } else if (textField.text.length > 4) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
            [self hideKeyboard:2];
        }
        
        identifyStr=textField.text;
        NSLog(@"验证码 %@",identifyStr);
    }
    

    
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    heightFree=kScreenHeight-keyboardRect.size.height;
    
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    if (bottomFieldView.top == -60) {
        bottomFieldView.top = 30;
    }
}

#pragma mark Lazy
- (void)alertShowWithView:(UIView *)alertView style:(TYAlertControllerStyle)style  {
    self.alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:style];
    self.alertController.backgoundTapDismissEnable = NO;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

#pragma mark  选择公司
- (void)selectCompany {
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:@"complist/all"] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        
        NSError *error = nil;
        NSArray * companyArr = [NSJSONSerialization JSONObjectWithData:responseObject
                                                    options:NSJSONReadingAllowFragments
                                                          error:&error];
        NSLog(@"%@",companyArr);
        
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}


#pragma mark 验证码图片
- (void)requestImagePhotoIdentify {
}


#pragma mark 获取插件  用这个方法来确定使用明文密文（服务器）
-(void)getPlugincomponents {
}

//懒加载
- (UIButton *)certainButton {
    if (!_certainButton) {
        _certainButton = [[UIButton alloc] initWithFrame:CGRectMake(23, 180+30+32+97*multiple, kScreenWidth-46, 40)];
        _certainButton.backgroundColor=COLOR_YELLOW;
        _certainButton.layer.cornerRadius=5;
        _certainButton.layer.masksToBounds=YES;
        [_certainButton setTitle:@"确 定" forState:UIControlStateNormal];
        [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _certainButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_certainButton addTarget:self action:@selector(buttonTradeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_certainButton];
        
        
        CGSize forgetPasswordSize=[ToolHelper sizeForNoticeTitle:@"111" font:[UIFont systemFontOfSize:14]];
        UIButton *forgetPassword=[[UIButton alloc] initWithFrame:CGRectMake(_certainButton.left, _certainButton.bottom + 10, forgetPasswordSize.width+2*KSINGLELINE_WIDTH, 20)];
        [forgetPassword setTitle:@"111" forState:UIControlStateNormal];
        forgetPassword.titleLabel.font=[UIFont systemFontOfSize:14];
        [forgetPassword setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        [forgetPassword addTarget:self action:@selector(selectCompany) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetPassword];
        
    }
    return _certainButton;
}

//更换资金账号
-(void)replaceClick{
    [self.view bringSubviewToFront:moreCodeTableView];
    if ((isClose=!isClose)) {
        moreCodeTableView.hidden=NO;
        [moreCodeTableView reloadData];
        [self hideKeyboard:2];
    }else{
        moreCodeTableView.hidden=YES;
    }
    if (accountArray.count==0) {
        moreCodeTableView.hidden=YES;
        isClose=NO;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无账户记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
}

#pragma mark 屏幕点击手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard:0];//收起键盘
    moreCodeTableView.hidden=YES;
    isClose=NO;
}

#pragma mark 更多资金账号
-(void)createMoreCodeTableView{
    
    moreCodeTableView=[[UITableView alloc] initWithFrame:CGRectMake(54, 90, kScreenWidth-54-20, 150)];
    moreCodeTableView.backgroundColor=COLOR_WHITE;
    moreCodeTableView.delegate=self;
    moreCodeTableView.dataSource=self;
    moreCodeTableView.bounces=NO;
    moreCodeTableView.hidden = YES;
    moreCodeTableView.layer.masksToBounds = NO;
    moreCodeTableView.layer.shadowColor = COLOR_LINE.CGColor;
    moreCodeTableView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    moreCodeTableView.layer.shadowOpacity = 0.5f;
    moreCodeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:moreCodeTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (accountArray.count == 0) {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return accountArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReplaceCell *cell = [ReplaceCell replaceTableViewCell:tableView type:FUND_CODE];
    
    if (accountArray.count != 0) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:100300];
        cell.leftLabel.text=accountArray[indexPath.row];
        cell.rightButton.tag=indexPath.row+100600;
        [cell.rightButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([textField.text isEqualToString:accountArray[indexPath.row]]) {
            cell.rightButton.enabled=NO;
            cell.rightButton.hidden = YES;
        }else{
            cell.rightButton.enabled=YES;
            cell.rightButton.hidden = NO;
        }
    }
    
    return cell;
}
-(void)deleteClick:(UIButton *)sender{
    
    [accountArray removeObjectAtIndex:sender.tag - 100600];
    
    [moreCodeTableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self clearTextFieldContent];
    
    UITextField *textField = [self.view viewWithTag:100300];
    
    textField.text=accountArray[indexPath.row];
    _fundCode=textField.text;
    [self hideKeyboard:2];
    moreCodeTableView.hidden=YES;
    isClose=NO;
    
    NSMutableArray *temArray=[accountArray mutableCopy];
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<temArray.count; i++) {
        if (![temArray[i] isEqualToString:accountArray[indexPath.row]]) {
            [arr addObject:temArray[i]];
        }
    }
    [accountArray removeAllObjects];
    [accountArray addObject:self.fundCode];
    
    for (NSString *strCode in arr) {
        [accountArray addObject:strCode];
    }
    [moreCodeTableView reloadData];
}



#pragma mark 创建3个textField框
- (void)createTextFieldThree {
    //获取尺寸
    CGSize codeSize=[ToolHelper sizeForNoticeTitle:@"更换资金账号" font:[UIFont boldSystemFontOfSize:15]];
    //图标集
    NSArray *imageArray=@[@"consumer",@"secret",@"identifyingcode",@"secretblue"];
    //创建地板
    bottomFieldView = [[UIView alloc] initWithFrame:CGRectMake(0,30,kScreenWidth,180)];
    [self.view addSubview:bottomFieldView];
    
    for (int i=0; i<2; i++) {
        UIView *fundView=[[UIView alloc] initWithFrame:CGRectMake(0, i*60, kScreenWidth, 60)];
        fundView.backgroundColor=[UIColor whiteColor];
        [bottomFieldView addSubview:fundView];
        
        if (i==2) {
            //显示验证码界面
            rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-140, 13, 120, 60-26)];
            rightImageView.userInteractionEnabled=YES;
            [fundView addSubview:rightImageView];
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identifyImageClick:)];
            [rightImageView addGestureRecognizer:tap];
            
            titleThreeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightImageView.width, rightImageView.height)];
            titleThreeLabel.text=@"重新加载";
            titleThreeLabel.font=[UIFont systemFontOfSize:13];
            titleThreeLabel.textColor=COLOR_LIGHTGRAY;
            titleThreeLabel.textAlignment=NSTextAlignmentRight;
            titleThreeLabel.hidden=YES;
            [rightImageView addSubview:titleThreeLabel];
            
        }else if (i==0) {
            rightArrowButton=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-52, 0, 52, 60)];
            [rightArrowButton setImage:[UIImage imageNamed:@"downjiantou"] forState:UIControlStateNormal];
            [rightArrowButton setImage:[UIImage imageNamed:@"downjiantou"] forState:UIControlStateSelected];
            [rightArrowButton addTarget:self action:@selector(replaceClick) forControlEvents:UIControlEventTouchUpInside];
            [fundView addSubview:rightArrowButton];
        }
        
        UIView *lineView=[[UIView alloc] init];
        if (i==2) {
            lineView.frame=CGRectMake(0, 60-KSINGLELINE_WIDTH, kScreenWidth, KSINGLELINE_WIDTH);
        }else{
            lineView.frame=CGRectMake(20, 60-KSINGLELINE_WIDTH, kScreenWidth-20, KSINGLELINE_WIDTH);
        }
        lineView.backgroundColor=COLOR_LINE;
        [fundView addSubview:lineView];
        
        UIButton *LeftButton=[[UIButton alloc] init];
        [LeftButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        
        if (i==0) {
            LeftButton.frame=CGRectMake(20, (60-21)/2, 19, 21);
            LeftButton.userInteractionEnabled=NO;
        }else if (i==1){
            LeftButton.frame=CGRectMake(20, (60-21)/2, 18, 21);
            LeftButton.userInteractionEnabled=NO;
        }else if (i==2){
            LeftButton.userInteractionEnabled=NO;
            LeftButton.frame=CGRectMake(20, (60-21)/2, 21, 21);
        }
        [fundView addSubview:LeftButton];
        
        UITextField *numberField=[[UITextField alloc] init];
        numberField.borderStyle=UITextBorderStyleNone;
        
        if (i==0) {
            numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
            numberField.placeholder=@"请输入账号";
        }else if(i==1){
            numberField.clearButtonMode = UITextFieldViewModeNever;
            numberField.placeholder=@"请输入密码";
        }else if (i==2){
            numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
            numberField.placeholder=@"请输入验证码";
        }
        numberField.keyboardType = UIKeyboardTypeEmailAddress;
        numberField.secureTextEntry=NO;//默认密文
        numberField.tintColor=COLOR_BLUE;
        numberField.tag=100300+i;
        numberField.delegate = self;
        numberField.textAlignment=NSTextAlignmentLeft;
        numberField.font=[UIFont systemFontOfSize:15];
        numberField.inputAccessoryView = [UIView new];
        [fundView addSubview:numberField];
        
        [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fundView.mas_left).offset(54);
            make.top.mas_equalTo(fundView.mas_top).offset(0);
            if (i == 0) {
                if ((![ToolHelper isBlankString:@""])) {
                    make.size.mas_equalTo(CGSizeMake(kScreenWidth - 54 - 10 - (codeSize.width + 15) - 20, 60));
                } else {
                    make.size.mas_equalTo(CGSizeMake(kScreenWidth - 54 - 20, 60));
                }
            }
            if (i == 1) {
                make.size.mas_equalTo(CGSizeMake(kScreenWidth - 54 - 20, 60));
            }
            if (i == 2) {
                make.size.mas_equalTo(CGSizeMake(kScreenWidth - 54 - 140 - 10, 60));
            }
        }];
    }
}

//清除输入框内容
-(void)clearTextFieldContent{
    
    UITextField *two = [self.view viewWithTag:100301];
    UITextField *three = [self.view viewWithTag:100302];
    if (two) {
        two.text = @"";
        [two resignFirstResponder];
    }
    if (three) {
        three.text = @"";
        [three resignFirstResponder];
    }
    identifyStr = @"";
    _selectStr = @"";
    
}

#pragma mark rightAction
- (void)rightAction {
    
}

- (void)controlUserInteraction:(BOOL)isEnabled {
    
}

@end

