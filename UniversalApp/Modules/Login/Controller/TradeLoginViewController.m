
//  TradeLoginViewController.m
//  PanGu
//
//  Created by Fll on 16/8/13.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "TradeLoginViewController.h"
#import "HttpRequest.h"
#import "UUCompanyListViewController.h"
#import <MOFSPickerManager.h>//提示框

#define messageVerifyTime   6

@interface TradeLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>{
    BOOL isScect;
    BOOL res;
    CGFloat heightFree;//iphone4 上移输入框
    UIView *bottomFieldView;//底板
    LMJWordItem *_item;//选择的会员公司
    NSInteger timerNum;//计时时间
    NSString *_verificationStr;//短信验证码
    
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

#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _isLostPassword ? @"忘记密码" : @"登录";
    timerNum = messageVerifyTime;
    heightFree = 0;
    [self.view addSubview:self.certainButton];
    [self createTextFieldThree];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageWithColor:COLOR_BLUE] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //初始化数据
    [self hideKeyboard:0];

    //检测 APP 合法性, 配置加密键盘
    NSString *fundStr = @"";
    if (![ToolHelper isBlankString:fundStr]) {
        UITextField *fundCodeField = [self.view viewWithTag:100300];
        fundCodeField.text=fundStr;
        _fundCode=fundStr;
    }
    
    if (_isLostPassword) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backViewController)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void) backViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyboard:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (bottomFieldView.top == -60) {
        bottomFieldView.top = 30;
    }
}

#pragma mark 登录按钮
- (void)buttonTradeClick {

    if (![self companyCodeExist]) return;
    if (![self mobileNumExist]) return;

    UITextField *accountTF = [self.view viewWithTag:100300];
    UITextField *passwordTFandverification = [self.view viewWithTag:100301];
//    UITextField *verificationTF = [self.view viewWithTag:100302];
    
    if (_isLostPassword) {
        if (![_verificationStr isEqualToString:passwordTFandverification.text]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"请输入正确的短信验证码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
            
            return ;
        } else {
            KPostNotification(KNotificationLoginStateChange, @YES);
            return;
        }
    } else {
        if (passwordTFandverification.text.length < 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:@"请输入正确的密码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
            
            return ;
        }
    }
    
    //[NSString stringWithFormat:@"VipLogin/%@/%@/%@",_item.subTitle,accountTF.text,passwordTF.text]
    //@"VipLogin/s0166/18971091245/123"
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:[NSString stringWithFormat:@"VipLogin/%@/%@/%@",_item.subTitle,accountTF.text,passwordTFandverification.text]] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",dict);
        if ([dict[@"Id"] length] > 0) {
            [defaults setObject:dict forKey:KUserData];
            KPostNotification(KNotificationLoginStateChange, @YES);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:dict[@"ErrMsg"] message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        }
       
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
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
        [defaults setObject:_item.subTitle forKey:KCompanyCode];
    };
    [self.navigationController pushViewController:compList animated:YES];
}

//懒加载
- (UIButton *)certainButton {
    if (!_certainButton) {
        _certainButton = [[UIButton alloc] initWithFrame:CGRectMake(23, 180+30+32+97, kScreenWidth-46, 40)];
        _certainButton.backgroundColor=COLOR_YELLOW;
        _certainButton.layer.cornerRadius=5;
        _certainButton.layer.masksToBounds=YES;
        [_certainButton setTitle:_isLostPassword ? @"确定验证码" : @"确 定" forState:UIControlStateNormal];
        [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _certainButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_certainButton addTarget:self action:@selector(buttonTradeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_certainButton];
        //选择公司
        CGSize selectCompany=[ToolHelper sizeForNoticeTitle:@"选择公司" font:[UIFont systemFontOfSize:14]];
        UIButton *selectC=[[UIButton alloc] initWithFrame:CGRectMake(_certainButton.left, _certainButton.bottom + 10, selectCompany.width+2*KSINGLELINE_WIDTH, 20)];
        selectC.tag = 999000;
        [selectC setTitle:@"选择公司" forState:UIControlStateNormal];
        selectC.titleLabel.font=[UIFont systemFontOfSize:14];
        [selectC setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        [selectC addTarget:self action:@selector(selectCompany) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectC];
        //忘记密码
        if (!_isLostPassword) {
            CGSize forgetPasswordSize=[ToolHelper sizeForNoticeTitle:@"忘记密码" font:[UIFont systemFontOfSize:14]];
            UIButton *forgetBnt=[[UIButton alloc] initWithFrame:CGRectMake(0, _certainButton.bottom + 10, forgetPasswordSize.width+2*KSINGLELINE_WIDTH, 20)];
            forgetBnt.right = _certainButton.right;
            forgetBnt.tag = 999000;
            [forgetBnt setTitle:@"忘记密码" forState:UIControlStateNormal];
            forgetBnt.titleLabel.font=[UIFont systemFontOfSize:14];
            [forgetBnt setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
            [forgetBnt addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:forgetBnt];
        }
    }
    return _certainButton;
}
//忘记密码
- (void) forgetPassword {
    TradeLoginViewController *lostPasswordV = [[TradeLoginViewController alloc]init];
    lostPasswordV.isLostPassword = YES;
    [self.navigationController pushViewController:lostPasswordV animated:YES];
    
}

#pragma mark 屏幕点击手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard:0];//收起键盘
}

#pragma mark 创建3个textField框
- (void)createTextFieldThree {
    //获取尺寸
    CGSize codeSize=[ToolHelper sizeForNoticeTitle:@"更换资金账号" font:[UIFont boldSystemFontOfSize:15]];
    //图标集
    NSArray *imageArray=@[@"icons8-merchant_account",@"icons8-equity_security",@"icons8-equity_security",@"secretblue"];
    //创建地板
    bottomFieldView = [[UIView alloc] initWithFrame:CGRectMake(0,30,kScreenWidth,180)];
    [self.view addSubview:bottomFieldView];
    
    for (int i=0; i<2; i++) {
        UIView *fundView=[[UIView alloc] initWithFrame:CGRectMake(0, i*60, kScreenWidth, 60)];
        fundView.backgroundColor=[UIColor whiteColor];
        [bottomFieldView addSubview:fundView];
        
        UIView *lineView=[[UIView alloc] init];
        if (i==1) {
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
            if (_isLostPassword) {
                LeftButton.userInteractionEnabled=NO;
                LeftButton.frame=CGRectMake(20, (60-21)/2, 21, 21);
            } else {
                LeftButton.frame=CGRectMake(20, (60-21)/2, 18, 21);
                LeftButton.userInteractionEnabled=NO;
            }
        }else if (i==2){
           
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
            if (_isLostPassword) {
                numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
                numberField.placeholder=@"请输入验证码";
            } else {
                numberField.clearButtonMode = UITextFieldViewModeNever;
                numberField.secureTextEntry = YES;
                numberField.placeholder=@"请输入密码";
                numberField.keyboardType = UIKeyboardTypeEmailAddress;
            }
            
        }else if (i==2){
            
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
        if (_isLostPassword && i == 1) {
            uWeakSelf
            UIButton *sendMsg = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 100, 0, 100, 60) buttonTitle:@"短信验证码" normalBGColor:COLOR_GREEN selectBGColor:COLOR_BLUE normalColor:COLOR_DARKGREY selectColor:COLOR_DARKGREY buttonFont:[UIFont systemFontOfSize:12] cornerRadius:5 doneBlock:^(UIButton *sender) {
                [weakSelf sendMsgVerification:sender];
                
            }];
            [fundView addSubview:sendMsg];
        }
    }
}
//验证公司
- (BOOL)companyCodeExist {
    //验证所属公司是否选择
    if (_item.subTitle.length < 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController mj_showAlertWithTitle:@"请选择会员公司1" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionDefaultTitle(@"确认");
                
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
            }];
        });
        
        return NO;
    }
    return YES;
}

- (BOOL)mobileNumExist {
    UITextField *accountTF = [self.view viewWithTag:100300];
    if (accountTF.text.length < 6) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController mj_showAlertWithTitle:@"请输入正确格式的手机号码" message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionDefaultTitle(@"确认");
                
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
            }];
        });
        return NO;
    }
    return YES;
}

- (void) sendMsgVerification:(UIButton *)sender {
    UITextField *accountTF = [self.view viewWithTag:100300];
    //验证所属公司是否选择
    if (![self companyCodeExist]) return;
    if (![self mobileNumExist]) return;
     //调用发送短信验证码接口************ChkVipTele/公司编号/手机号
    [[HttpRequest getInstance] postWithURLString:[BASEURL stringByAppendingString:[NSString stringWithFormat:@"ChkVipTele/%@/%@",[defaults objectForKey:KCompanyCode],accountTF.text]] headers:nil orbYunType:OrbYunHttp parameters:nil success:^(id responseObject, NSURLSessionTask *task) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        [defaults setObject:dict forKey:KUserData];
        NSLog(@"%@",dict);
        sender.enabled = NO;
        sender.userInteractionEnabled = NO;
        if ([dict[@"Id"] length] > 0) {
            //按钮计时
            _verificationStr = dict[@"Code"];
            [self buttonTimer:sender];
        }else{
            sender.enabled = YES;
            sender.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController mj_showAlertWithTitle:dict[@"ErrMsg"] message:@"I am sorry!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                    alertMaker.addActionDefaultTitle(@"确认");
                    
                } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                    
                }];
            });
        }
       
    } failure:^(NSError *error, NSURLSessionTask *task) {
        NSLog(@"%@",[error localizedDescription]);
        [sender setTitle:@"NO网络，重试" forState:UIControlStateNormal];
        
    }];
    
}
//按钮计时
- (void) buttonTimer:(UIButton *) sender  {
    //按钮计时
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        timerNum -= 1;
        if (timerNum < 1) {
            timerNum = 6;
            sender.enabled = YES;
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"短信验证码" forState:UIControlStateNormal];
            [timer invalidate];
            timer = nil;
            return;
        }
        [sender setTitle:[NSString stringWithFormat:@"剩余%@s",[@(timerNum) stringValue]]forState:UIControlStateNormal];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
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


@end

