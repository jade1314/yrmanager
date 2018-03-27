
//  TradeLoginViewController.m
//  PanGu
//
//  Created by Fll on 16/8/13.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "TradeLoginViewController.h"

#import "UIView+TYAlertView.h"
#import "HttpRequest.h"
#import "UsersModel.h"
#import "OpenUDID.h"
#import <sys/utsname.h>
#import "RegisterLoginViewController.h"
#import "TradeLoginStartViewController.h"
#import "GetIpHelper.h"
#import "ReplaceCell.h"
#import "UUCompanyListViewController.h"
#import <MOFSPickerManager.h>//提示框

#define multiple  kScreenHeight/667 //倍数
#define multiple_w  kScreenWidth/375 //倍数
#define messageVerifyTime   @"120"
#define voiceVerifyTime     @"120"

@interface TradeLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL isScect;
    BOOL res;
    CGFloat heightFree;//iphone4 上移输入框
    UIView *bottomFieldView;//底板
    NSInteger lengthNum;
    NSString *clickLogin;//客服热线  防止误触
    NSInteger clickReplaceNum;//保证只跳一次更换资金账号 防止误触
    NSString *OUTIP;
    BOOL isClose;//下拉列表的收缩状态
    BOOL    isFirst;
    
    LMJWordItem *_item;//选择的会员公司
    
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
    [self.view addSubview:self.certainButton];
    [self createTextFieldThree];
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

#pragma mark 登录按钮
- (void)buttonTradeClick {

    if (_item.subTitle.length < 1) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController mj_showAlertWithTitle:@"请选择会员公司1" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {

                alertMaker.addActionDefaultTitle(@"确认");

            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {

            }];
        });

        return;
    }

    UITextField *accountTF = [self.view viewWithTag:100300];
    UITextField *passwordTF = [self.view viewWithTag:100301];
    if (accountTF.text.length < 6) {

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertController mj_showAlertWithTitle:@"请输入正确格式的手机号码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {

            alertMaker.addActionDefaultTitle(@"确认");

        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {

        }];
    });

        return;
    }
    if (passwordTF.text.length < 6) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController mj_showAlertWithTitle:@"请输入正确的密码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {

                alertMaker.addActionDefaultTitle(@"确认");

            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {

            }];
        });

        return ;//[NSString stringWithFormat:@"VipLogin/%@/%@/%@",_item.subTitle,accountTF.text,passwordTF.text]
    }//
    [defaults setObject:_item.subTitle forKey:KCompanyCode];
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:@"VipLogin/s0166/18971091245/123"] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",dict);
        [defaults setObject:dict forKey:KUserData];
        KPostNotification(KNotificationLoginStateChange, @YES);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
        KPostNotification(KNotificationLoginStateChange, @YES);
    }];
    
}

//跳转
-(void)transactionAccountToken:(NSString *)tokenString old_SRRC:(NSString *)srrc old_TCC:(NSString *)tcc isOverdue:(NSString *)isOverdue endDate:(NSString *)endDate riskLevel:(NSString *)riskLevel {
    
    
    
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
            
        }
        
    }else if (textField.tag==100301){
        _selectStr=textField.text;//明文时的密码
        if ([ToolHelper isBlankString:textField.text]) {
            
        }
        
        NSLog(@"密码 %@",_selectStr);
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
    UUCompanyListViewController *compList = [UUCompanyListViewController new];
    compList.compB = ^(LMJWordItem *item) {
        self.title = item.title;
        _item = item;
    };
    [self.navigationController pushViewController:compList animated:YES];
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
        
        
        CGSize forgetPasswordSize=[ToolHelper sizeForNoticeTitle:@"选择公司" font:[UIFont systemFontOfSize:14]];
        UIButton *selectC=[[UIButton alloc] initWithFrame:CGRectMake(_certainButton.left, _certainButton.bottom + 10, forgetPasswordSize.width+2*KSINGLELINE_WIDTH, 20)];
        selectC.tag = 999000;
        [selectC setTitle:@"选择公司" forState:UIControlStateNormal];
        selectC.titleLabel.font=[UIFont systemFontOfSize:14];
        [selectC setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        [selectC addTarget:self action:@selector(selectCompany) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectC];
        
    }
    return _certainButton;
}

#pragma mark 屏幕点击手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard:0];//收起键盘
    isClose=NO;
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
            numberField.secureTextEntry=NO;//默认密文
            numberField.keyboardType = UIKeyboardTypeNumberPad;
        }else if(i==1){
            numberField.clearButtonMode = UITextFieldViewModeNever;
            numberField.secureTextEntry = YES;
            numberField.placeholder=@"请输入密码";
            numberField.keyboardType = UIKeyboardTypeEmailAddress;
        }else if (i==2){
            numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
            numberField.placeholder=@"请输入验证码";
        }
        
       
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

#pragma mark rightAction
- (void)rightAction {
    
}

- (void)controlUserInteraction:(BOOL)isEnabled {
    
}

@end

