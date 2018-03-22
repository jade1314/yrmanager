//
//  RegisterLoginViewController.m
//  PanGu
//
//  Created by Fll on 16/8/16.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "RegisterLoginViewController.h"
#import "UsersModel.h"
#import "HttpRequest.h"
#import "TYAlertController.h"
#import "TradeErrorAlertView.h"

#import "TradeLoginStartViewController.h"
//#import "NetworkRequest.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "MyAttributedStringBuilder.h"
#import "WXApi.h"

//#import "Unikey.h"
#import "OpenUDID.h"
//#import "tdxMsgPushOper.h"// 通达信

#define COLOR_LIGHT_GREEN [ToolHelper colorWithHexString:@"#8cc740"]
#define multiple  kScreenHeight/667 //倍数
#define multiple_w  kScreenWidth/375 //倍数
#define messageVerifyTime   @"120"
#define voiceVerifyTime     @"120"

@interface RegisterLoginViewController ()<UITextFieldDelegate>
{
    UIView *phoneView;//输入注册号的底板
    UIView *verifyView;//输入验证码的底板
    UIView *picVerifyView;//输入图片验证码的底板
    UIButton *_certainButton;//注册登录按钮
    
    NSTimer *messageTimer;//短信验证码计时器
    NSInteger messageTick;//短信间隔时长
    NSTimer *voiceTimer;//语音验证码计时器
    NSInteger voiceTick;//语音间隔时长
    
    UITextField *verifyField;//验证码输入框
    UITextField *phoneField;//手机输入框
    UITextField *picVerifyField;//图片验证码输入框
    
    NSString *phoneStr;//手机号字符串
    NSString *messageVerifyStr;//短信字符串
    NSString *voiceVerifyStr;//语音字符串
    NSString *picVerifyStr;//图片字符串
    
    
    BOOL getVerify;//判断是否点击获取验证码
    UIActivityIndicatorView *_activityLoading;

}

@property (nonatomic, strong) UIButton *picVerifyButton;//图片验证码按钮
@property (nonatomic, strong) UIButton *messageVerifyButton;//短信点击按钮
@property (nonatomic, strong) UIButton *voiceVerifyButton;//语音点击按钮
@property (nonatomic, strong) UIView *voiceVerifyBottomView;//显示语音提示语的底板

@end

@implementation RegisterLoginViewController

#pragma mark ✨✨✨ viewWillDisappear ✨✨✨
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([messageTimer isValid]) {
        [messageTimer invalidate];
        messageTimer=nil;
    }
    if ([voiceTimer isValid]) {
        [voiceTimer invalidate];
        voiceTimer=nil;
    }
}


- (void)hideActivityLoading {
    [_activityLoading stopAnimating];
}

#pragma mark ✨✨✨ viewDidLoad ✨✨✨
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor=COLOR_BLUE;
    self.view.backgroundColor=COLOR_BACK;
//    [self addLeftBtWithImage:@"backicon.png" offSet:0.0f];
    self.navigationItem.title = @"注册登录";

    getVerify=NO;
    
    phoneView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 50*multiple)];
    phoneView.backgroundColor=[UIColor whiteColor];
    phoneView.layer.cornerRadius = 5;
    [self.view addSubview:phoneView];
    
    UIButton *LeftPhoneButton=[[UIButton alloc] init];
    [LeftPhoneButton setImage:[UIImage imageNamed:@"shoujichuce"] forState:UIControlStateNormal];
    LeftPhoneButton.frame=CGRectMake(17, (50*multiple-19)/2, 15, 19);
    LeftPhoneButton.userInteractionEnabled=NO;
    [phoneView addSubview:LeftPhoneButton];

    UIButton *phoneButton=[[UIButton alloc] initWithFrame:CGRectMake(LeftPhoneButton.right+8, 0, 25, 50*multiple)];
    [phoneButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    phoneButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [phoneButton setTitle:@"+86" forState:UIControlStateNormal];
    phoneButton.userInteractionEnabled=NO;
    [phoneView addSubview:phoneButton];
    
    UIView *lineView=[[UIView alloc] init];
    lineView.frame=CGRectMake(72-KSINGLELINE_WIDTH, (50*multiple-20)/2, KSINGLELINE_WIDTH, 20);
    lineView.backgroundColor=COLOR_LINE;
    [phoneView addSubview:lineView];
    
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(lineView.right+10, 0, phoneView.width-90, 50*multiple)];
    phoneField.borderStyle=UITextBorderStyleNone;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    phoneField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    phoneField.tintColor=COLOR_BLUE;
    phoneField.tag=102200;
    phoneField.placeholder=@"请输入手机号";
    phoneField.delegate = self;
    phoneField.font=[UIFont systemFontOfSize:15*multiple];
    [phoneView addSubview:phoneField];
    
    //输入框点击响应事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    picVerifyView=[[UIView alloc] initWithFrame:CGRectMake(20, 20+50*multiple+20, 160-20+50*multiple, 50*multiple)];
    picVerifyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:picVerifyView];
    picVerifyView.layer.cornerRadius = 5;
    
    UIButton *picLeftVerifyButton=[[UIButton alloc] init];
    [picLeftVerifyButton setImage:[UIImage imageNamed:@"identifyingcode"] forState:UIControlStateNormal];
    picLeftVerifyButton.frame=CGRectMake(17, (50*multiple-15)/2, 15, 15);
    picLeftVerifyButton.userInteractionEnabled=NO;
    [picVerifyView addSubview:picLeftVerifyButton];
    
    picVerifyField=[[UITextField alloc] initWithFrame:CGRectMake(picLeftVerifyButton.right+12, 0, picVerifyView.width-40, 50*multiple)];
    picVerifyField.borderStyle=UITextBorderStyleNone;
    picVerifyField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    picVerifyField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    picVerifyField.tintColor=COLOR_BLUE;
    picVerifyField.tag=102202;
    picVerifyField.placeholder=@"请输入验证码";
    picVerifyField.delegate = self;
    picVerifyField.font=[UIFont systemFontOfSize:15*multiple];
    [picVerifyView addSubview:picVerifyField];
    
    CGFloat picVerifyWidth = (kScreenWidth-picVerifyView.right-20-10);
    _picVerifyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _picVerifyButton.frame = CGRectMake(picVerifyView.right + 10 + 20, phoneView.bottom + 20 + (50 - 35) * multiple/2, picVerifyWidth - 40, 35*multiple);
    _picVerifyButton.backgroundColor=[UIColor clearColor];
    [_picVerifyButton setTitle:@"" forState:UIControlStateNormal];
    [_picVerifyButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    _picVerifyButton.adjustsImageWhenHighlighted = NO;

    [_picVerifyButton addTarget:self action:@selector(clickPicVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    _picVerifyButton.layer.borderColor = COLOR_LINE.CGColor;
    _picVerifyButton.layer.borderWidth = KSINGLELINE_WIDTH;
    _picVerifyButton.titleLabel.font=[UIFont systemFontOfSize:14*multiple];
    _picVerifyButton.tag = 94602;
    [self.view addSubview:_picVerifyButton];
    

    
    verifyView=[[UIView alloc] initWithFrame:CGRectMake(20, 20+(50*multiple+20)*2, 160-20+50*multiple, 50*multiple)];
    verifyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:verifyView];
    verifyView.layer.cornerRadius = 5;
    
    UIButton *LeftVerifyButton=[[UIButton alloc] init];
    [LeftVerifyButton setImage:[UIImage imageNamed:@"suozhuce"] forState:UIControlStateNormal];
    LeftVerifyButton.frame=CGRectMake(17, (50*multiple-15)/2, 15, 15);
    LeftVerifyButton.userInteractionEnabled=NO;
    [verifyView addSubview:LeftVerifyButton];

    verifyField=[[UITextField alloc] initWithFrame:CGRectMake(LeftVerifyButton.right+12, 0, verifyView.width-40, 50*multiple)];
    verifyField.borderStyle=UITextBorderStyleNone;
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    verifyField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    verifyField.tintColor=COLOR_BLUE;
    verifyField.tag=102201;
    verifyField.placeholder=@"请输入6位验证码";
    verifyField.delegate = self;
    verifyField.font=[UIFont systemFontOfSize:15*multiple];
    [verifyView addSubview:verifyField];
    
    CGFloat messageVerifyWidth = (kScreenWidth-verifyView.right-20-10);
    _messageVerifyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _messageVerifyButton.frame = CGRectMake(verifyView.right + 10, picVerifyView.bottom + 20, messageVerifyWidth, 50 * multiple);
    _messageVerifyButton.backgroundColor=COLOR_LIGHT_GREEN;
    [_messageVerifyButton setTitle:@"短信验证码" forState:UIControlStateNormal];
    [_messageVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_messageVerifyButton addTarget:self action:@selector(getVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    _messageVerifyButton.titleLabel.font=[UIFont systemFontOfSize:14*multiple];
    _messageVerifyButton.layer.cornerRadius = 5;
    _messageVerifyButton.layer.masksToBounds = YES;
    _messageVerifyButton.tag = 94600;
    [self.view addSubview:_messageVerifyButton];
    _certainButton=[[UIButton alloc] initWithFrame:CGRectMake(20, verifyView.bottom + 35, kScreenWidth-40, 50*multiple)];//60
    _certainButton.backgroundColor=[ToolHelper colorWithHexString:@"b3b3b3"];
    [_certainButton setTitle:@"注册登录" forState:UIControlStateNormal];
    [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainButton.titleLabel.font=[UIFont systemFontOfSize:16*multiple];
    [_certainButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    _certainButton.userInteractionEnabled=NO;
    _certainButton.layer.cornerRadius=5;
    [self.view addSubview:_certainButton];
    
    //创建语音显示模块
    [self createVoiceView];
    
    //在手机安装微信的情况下 才显示微信注册按钮
    if ([WXApi isWXAppInstalled]) {
        [self createThirdPlatform];//创建其他注册方式
    }
    [self requestPicVerify];

}


#pragma mark ✨✨✨ 创建语音验证码View ✨✨✨
- (void)createVoiceView {
    _voiceVerifyBottomView = [[UIView alloc]initWithFrame:CGRectMake(20, _certainButton.bottom + 20, kScreenWidth - 40, 50 * multiple)];
    _voiceVerifyBottomView.layer.cornerRadius = 5;
    _voiceVerifyBottomView.layer.borderWidth = KSINGLELINE_WIDTH;
    _voiceVerifyBottomView.layer.borderColor = COLOR_RED.CGColor;
    _voiceVerifyBottomView.hidden = YES;
    [self.view addSubview:_voiceVerifyBottomView];
    
    CGSize  voiceLabelSize = [ToolHelper sizeForNoticeTitle:@"如果没收到短信验证码，请您尝试" font:[UIFont systemFontOfSize:isiPhoneX ? 13 : (14 * multiple)]];
    CGSize  voiceButtonTextSize = [ToolHelper sizeForNoticeTitle:@"语音验证码" font:[UIFont systemFontOfSize:isiPhoneX ? 13 : (14 * multiple)]];
    CGFloat leftX = (kScreenWidth - 40 - (13 + 6 + voiceLabelSize.width + 5 + voiceButtonTextSize.width))/2;
    UIImageView *warnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftX, 0 , 13, 50*multiple)];
    warnImageView.contentMode = UIViewContentModeCenter;
    warnImageView.image = ImageNamed(@"registerWarning");
    [_voiceVerifyBottomView addSubview:warnImageView];
    
    UILabel *voiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(warnImageView.right + 6, 0, voiceLabelSize.width, 50 * multiple)];
    voiceLabel.font = [UIFont systemFontOfSize:isiPhoneX ? 13 : (14 * multiple)];
    voiceLabel.text = @"如果没收到短信验证码，请您尝试";
    voiceLabel.textColor = [ToolHelper colorWithHexString:@"#808080"];
    [_voiceVerifyBottomView addSubview:voiceLabel];
    
    UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(voiceLabel.right + 5, (50 * multiple)/2+voiceButtonTextSize.height/2 + 2, voiceButtonTextSize.width, KSINGLELINE_WIDTH)];
    singleView.backgroundColor = COLOR_LIGHT_GREEN;
    [_voiceVerifyBottomView addSubview:singleView];
    
    _voiceVerifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceVerifyButton.frame = CGRectMake(voiceLabel.right + 5, 0, voiceButtonTextSize.width + leftX, 50 * multiple);
    [_voiceVerifyButton setTitle:@"语音验证码" forState:UIControlStateNormal];
    _voiceVerifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _voiceVerifyButton.titleLabel.font = [UIFont systemFontOfSize:isiPhoneX ? 13 : (14 * multiple)];
    [_voiceVerifyButton setTitleColor:COLOR_LIGHT_GREEN forState:UIControlStateNormal];
    _voiceVerifyButton.tag = 94601;
    [_voiceVerifyBottomView addSubview:_voiceVerifyButton];
    [_voiceVerifyButton addTarget:self action:@selector(getVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark  点击图片验证码
- (void)clickPicVerifyButton:(UIButton *)sender {
    [_picVerifyButton setTitle:@"" forState:UIControlStateNormal];
    [_picVerifyButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    
    [self requestPicVerify];
}

- (void)showActivityLoading:(UIView *)view {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:view.bounds];
    activityView.userInteractionEnabled = YES;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityLoading = activityView;
    [view addSubview:_activityLoading];
    [_activityLoading startAnimating];
}

#pragma mark  请求图片验证码
- (void)requestPicVerify {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[OpenUDID value] forKey:@"equipment"];
    
    [[HttpRequest getInstance] getWithURLString:@"" headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",result);
        NSString *code = result[@"code"];
        if ([code isEqualToString:@"0"]) {
            //
            NSData *_decodedImageData  = [[NSData alloc] initWithBase64EncodedString:result[@"message"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [_picVerifyButton setBackgroundImage:[UIImage imageWithData:_decodedImageData] forState:UIControlStateNormal];
            [_picVerifyButton setTitle:@"" forState:UIControlStateNormal];

        } else {
            [_picVerifyButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            [_picVerifyButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [DLLoading DLToolTipInWindow:result[@"message"]];
        }
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        
        NSLog(@"%@",[error localizedDescription]);
        [_picVerifyButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [_picVerifyButton setTitle:@"重新获取" forState:UIControlStateNormal];
        
        
        
        
    }];

}

#pragma mark ✨✨✨ 创建其他注册方式 ✨✨✨
- (void)createThirdPlatform {
    UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(20, (_certainButton.bottom+20+50+58+6+40)*multiple, kScreenWidth-40, KSINGLELINE_WIDTH)];
    singleView.backgroundColor = COLOR_LINE;
    [self.view addSubview:singleView];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-(12*multiple*6+18))/2, singleView.bottom - 12*multiple/2, 12*multiple*6+18, 12*multiple)];
    topLabel.text = @"其他注册方式";
    topLabel.textColor = COLOR_LIGHTGRAY;
    topLabel.font = [UIFont systemFontOfSize:12*multiple];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = COLOR_BACK;
    [self.view addSubview:topLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - 116)/2, singleView.bottom+24*multiple, 116, 32)];
    [self.view addSubview:backView];
    
    CGSize size = [ToolHelper sizeForNoticeTitle:@"微信登录" font:[UIFont systemFontOfSize:16*multiple]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((116 - (19 + 6 + size.width))/2, 0, 19, 32)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = ImageNamed(@"registerWeixin");
    [backView addSubview:imageView];
    UILabel *weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 6, 0, size.width + 4 * KSINGLELINE_WIDTH, 32)];
    weixinLabel.textAlignment = NSTextAlignmentLeft;
    weixinLabel.font = [UIFont systemFontOfSize:16*multiple];
    weixinLabel.text = @"微信登录";
    weixinLabel.textColor = COLOR_LIGHT_GREEN;
    [backView addSubview:weixinLabel];
    
    //为微信登陆增加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchThirdPlatform:)];
    [backView addGestureRecognizer:tap];

}

#pragma mark ✨✨✨ 点击微信登录按钮 ✨✨✨
//- (void)touchThirdPlatform:(UITapGestureRecognizer *)tap {
//
//
//    [[UMSocialManager defaultManager]authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//        if (error) {
//
//            NSLog(@"error error---------------授权失败");
//        } else {
//            [[UMSocialManager defaultManager]getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//                [self hideLoadingView];
//                if (error) {
//                    NSLog(@"%@",error.localizedDescription);
//                } else {
//                    UMSocialUserInfoResponse *resp = result;
//                    //  微信注册时，注册的类型是 3
//                    [self loginRegisterRequestType:@"3" openid:resp.openid nickName:resp.originalResponse[@"nickname"]];
//
//                    // 授权信息
//                    NSLog(@"Wechat uid: %@", resp.uid);
//                    NSLog(@"Wechat openid: %@", resp.openid);
//                    NSLog(@"Wechat accessToken: %@", resp.accessToken);
//                    NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//                    NSLog(@"Wechat expiration: %@", resp.expiration);
//
//                    // 用户信息
//                    NSLog(@"Wechat name: %@", resp.name);
//                    NSLog(@"Wechat iconurl: %@", resp.iconurl);
//                    NSLog(@"Wechat gender: %@", resp.gender);
//
//                    // 第三方平台SDK源数据
//                    NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//
//                }
//            }];
//
//        }
//    }];
//}


#pragma mark ✨✨✨ 点击获取验证码 ✨✨✨ 根据传入的tag值进行分别处理
-(void)getVerifyClick:(UIButton *)sender{
    NSLog(@"点击获取验证码");
    
    if ([phoneField.text isEqualToString:@""]) {
        [DLLoading DLToolTipInWindow:@"请输入手机号"];
        return;
    }
    if (![ToolHelper validateMobile:phoneField.text]){
        [DLLoading DLToolTipInWindow:@"请输入正确的手机号"];
        return;
    }
    
    if ([ToolHelper isBlankString:picVerifyField.text]) {
        [DLLoading DLToolTipInWindow:@"请输入图片验证码"];
        return;
    }
    
    if (picVerifyField.text.length != 4) {
        [DLLoading DLToolTipInWindow:@"请输入4位图片验证码"];
        return;
    }
    
    getVerify = YES;//点击获取验证码按钮

    UIButton *verifyButton = [self.view viewWithTag:sender.tag];
    if (sender.tag == 94600) {
        
        _messageVerifyButton.userInteractionEnabled = NO;
        _voiceVerifyButton.userInteractionEnabled = NO;
        
        NSString *str = [NSString stringWithFormat:@"重获短信%@",messageVerifyTime];
        [verifyButton setTitle:str forState:UIControlStateNormal];
        verifyButton.backgroundColor=[UIColor clearColor];
        [verifyButton setTitleColor:COLOR_LIGHT_GREEN forState:UIControlStateNormal];
        verifyButton.layer.borderColor=COLOR_LIGHT_GREEN.CGColor;
        verifyButton.layer.borderWidth=KSINGLELINE_WIDTH;
        
        messageTick=[messageVerifyTime integerValue];
        if (messageTimer == nil) {
            messageTimer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(RegisterMessageTimeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:messageTimer forMode:NSDefaultRunLoopMode];
        }
        
    } else if (sender.tag == 94601) {
        
        _voiceVerifyButton.userInteractionEnabled = NO;
        _messageVerifyButton.userInteractionEnabled = NO;
        
        NSString *str = [NSString stringWithFormat:@"重获语音%@",voiceVerifyTime];
        [_voiceVerifyButton setTitle:str forState:UIControlStateNormal];
        voiceTick=[voiceVerifyTime integerValue];
        if (voiceTimer == nil) {
            voiceTimer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(RegisterVoiceTimeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:voiceTimer forMode:NSDefaultRunLoopMode];
        }
    }

    [self requestVerifyWithTag:verifyButton.tag];
}

#pragma mark ✨✨✨ 计时器倒计时（短信） ✨✨✨
- (void)RegisterMessageTimeRun {
    messageTick--;
    if(messageTick==0){
        //计时结束，释放计时器
        if ([messageTimer isValid]) {
            [messageTimer invalidate];
            messageTimer=nil;
        }
        
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        // 显示语音
        _voiceVerifyBottomView.hidden = NO;
        
        _messageVerifyButton.userInteractionEnabled = YES;
        _voiceVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.backgroundColor=COLOR_LIGHT_GREEN;
        [_messageVerifyButton setTitle:@"重发短信" forState:UIControlStateNormal];
        [_messageVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        
        [_messageVerifyButton setTitle:[NSString stringWithFormat:@"重获短信%ld",messageTick] forState:UIControlStateNormal];
        
    }
}

#pragma mark ✨✨✨ 计时器倒计时（语音） ✨✨✨
- (void)RegisterVoiceTimeRun {
    voiceTick--;
    if(voiceTick==0){
        //计时结束，释放计时器
        if ([voiceTimer isValid]) {
            [voiceTimer invalidate];
            voiceTimer=nil;
        }
        
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        
        _voiceVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.userInteractionEnabled = YES;
        
        [_voiceVerifyButton setTitle:@"重发语音" forState:UIControlStateNormal];
        
    }else{

        [_voiceVerifyButton setTitle:[NSString stringWithFormat:@"重获语音%ld",voiceTick] forState:UIControlStateNormal];
    }
}


#pragma mark  新发送短信/语音
- (void)requestVerifyWithTag:(NSInteger)tag {
    
    //https://tnhq.tpyzq.com/note/send?phone=18701626374
    NSString *interfaceURL;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:phoneField.text forKey:@"phone"];
    [params setValue:[OpenUDID value] forKey:@"equipment"];
    [params setValue:picVerifyField.text forKey:@"auth"];
    
    if (tag == 94600) {
        
    } else if (tag == 94601) {
        
    }
    [[HttpRequest getInstance] getWithURLString:interfaceURL headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",result);
        NSString *code = result[@"code"];
        if (![code isEqualToString:@"0"]) {
            [self dealRequestError:result[@"message"] buttonTag:tag];
        }
        NSLog(@"7777");
    } failure:^(NSError *error, NSURLSessionTask *task) {
        //
        
        [self errorResultButtonTag:tag];
        
        NSLog(@"%@",[error localizedDescription]);
    }];
}


- (void)dealRequestError:(NSString *)title buttonTag:(NSInteger)tag {
    __block TYAlertController *aalertController;
    TradeErrorAlertView * alertView = [[TradeErrorAlertView alloc] initTitle:title?title:@"" clickTrueBlock:^{
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        [aalertController dismissViewControllerAnimated:YES];
    }];
    aalertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    aalertController.backgoundTapDismissEnable = NO;
    [self presentViewController:aalertController animated:YES completion:nil];
    
    [self errorResultButtonTag:tag];
}

-(void)errorResultButtonTag:(NSInteger)tag{
    if (tag == 94600) {
        if ([messageTimer isValid]) {
            [messageTimer invalidate];
            messageTimer=nil;
        }
        
//        _voiceVerifyBottomView.hidden = NO;
        
        _messageVerifyButton.userInteractionEnabled = YES;
        _voiceVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.backgroundColor=COLOR_LIGHT_GREEN;
        [_messageVerifyButton setTitle:@"重发短信" forState:UIControlStateNormal];
        [_messageVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } else if (tag == 94601) {
        
        if ([voiceTimer isValid]) {
            [voiceTimer invalidate];
            voiceTimer=nil;
        }
        
        _voiceVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.userInteractionEnabled = YES;
        
        [_voiceVerifyButton setTitle:@"重发语音" forState:UIControlStateNormal];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==102200) {
        phoneView.layer.borderColor=COLOR_YELLOW.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_WHITE.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_WHITE.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;

    }else if (textField.tag==102201){
        phoneView.layer.borderColor=COLOR_WHITE.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_YELLOW.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_WHITE.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;
    } else if (textField.tag==102202){
        phoneView.layer.borderColor=COLOR_WHITE.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_WHITE.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_YELLOW.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //验证码输入框是否可编辑判断
    if (textField.tag==102201) {
        if (getVerify==NO) {
            if ([ToolHelper isBlankString:phoneField.text]) {
                [DLLoading DLToolTipInWindow:@"请输入手机号"];
            }else{
                [DLLoading DLToolTipInWindow:@"请获取验证码"];
            }
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark ✨✨✨ 监听textField的text的改变 ✨✨✨
- (void)loginDidChange:(NSNotification *)notification {
    UITextField *textField = [notification object];
    
    NSLog(@"%@",textField.text);
    if (textField.tag == 102200) {
        if (textField.text.length == 11) {
            [self quitKeyboard];
        } else if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
            [self quitKeyboard];
        }
    } else if (textField.tag==102201){
        if (textField.text.length==6) {
            [self quitKeyboard];
        } else if (textField.text.length>6) {
            textField.text=[textField.text substringWithRange:NSMakeRange(0, 6)];
            [self quitKeyboard];
        }
    } else if (textField.tag == 102202) {
        if (textField.text.length == 4) {
            [self quitKeyboard];
        } else if (textField.text.length > 4) {
            textField.text=[textField.text substringWithRange:NSMakeRange(0, 4)];
            [self quitKeyboard];
        }
    }
    if ((![ToolHelper isBlankString:phoneField.text]) && (![ToolHelper isBlankString:verifyField.text]) && ![ToolHelper isBlankString:picVerifyField.text]) {
        _certainButton.backgroundColor=COLOR_YELLOW;
        _certainButton.userInteractionEnabled=YES;
    }else{
        _certainButton.backgroundColor=[ToolHelper colorWithHexString:@"b3b3b3"];//COLOR_LIGHTGRAY;
        _certainButton.userInteractionEnabled=NO;
    }

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self quitKeyboard];
}

#pragma mark ✨✨✨ 点击注册登录按钮 ✨✨✨
-(void)registerClick{
    
    if (![ToolHelper validateMobile:phoneField.text]){
        [DLLoading DLToolTipInWindow:@"请输入正确的手机号"];
        return;
    }
    
    
    _certainButton.userInteractionEnabled = NO;
    [self loginRegisterRequestType:@"1" openid:@"" nickName:@""];

}

#pragma mark ✨✨✨ 请求注册登录接口 ✨✨✨
-(void)loginRegisterRequestType:(NSString *)type openid:(NSString *)openid nickName:(NSString *)nickName {
    
    //存取钥匙串
    [Chain setPassword:@"" forService:@"com.tpyzq.PanGu" account:@"Token"];
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    NSString *interfaceStr;
    if ([type isEqualToString:@"1"]){//手机号注册
        [params setValue:[OpenUDID value] forKey:@"equipment"];//设备号
        [params setValue:phoneField.text forKey:@"phone"];//手机号
        [params setValue:verifyField.text forKey:@"auth"];//短信验证码
        [params setValue:@"2" forKey:@"phone_type"];//手机类型1.安卓 2.苹果 3.其他
#if TARGET_IPHONE_SIMULATOR//模拟器
        [params setObject:@"TARGET_IPHONE_SIMULATOR" forKey:@"token"];
#elif TARGET_OS_IPHONE//真机
        [params setValue:[defaults objectForKey:USER_TOKEN]?[defaults objectForKey:USER_TOKEN]:@"" forKey:@"token"];
#endif
        [params setValue:phoneField.text forKey:@"user_account"];//账户
        [params setValue:type forKey:@"user_type"];//账户类型 1：手机用户2：QQ用户 3：微信用户 4：微博用户 9：其他用户
        interfaceStr = @"";
        
        [[HttpRequest getInstance] getWithURLString:interfaceStr headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
            
            _certainButton.userInteractionEnabled = YES;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
            
            [self dealWithLoginRegisterRequestData:dic type:type openid:openid nickName:nickName isOld:NO];
            
        } failure:^(NSError *error, NSURLSessionTask *task) {
            
            _certainButton.userInteractionEnabled = YES;
            [DLLoading DLToolTipInWindow:@"注册失败"];
            
            
        }];
    } else if ([type isEqualToString:@"3"]) {//微信注册
        [parmDic setValue:openid forKey:@"user_account"];//账户号码
        [parmDic setValue:nickName forKey:@"nickname"];//昵称
        [parmDic setValue:type forKey:@"user_type"];//账户号码类型 1：手机用户2：QQ用户 3：微信用户 4：微博用户 9：其他用户
        [parmDic setValue:@"2" forKey:@"phone_type"];//手机类型1.安卓 2.苹果 3.其他
#if TARGET_IPHONE_SIMULATOR//模拟器
        [parmDic setValue:@"TARGET_IPHONE_SIMULATOR" forKey:@"token"];
#elif TARGET_OS_IPHONE//真机
        [parmDic setValue:[defaults objectForKey:USER_TOKEN]?[defaults objectForKey:USER_TOKEN]:@"" forKey:@"token"];
#endif
        [params setValue:@"800100" forKey:@"funcid"];
        [params setValue:@"" forKey:@"token"];
        [params setValue:parmDic forKey:@"parms"];
        interfaceStr = @"";
        
        [[HttpRequest getInstance] postWithURLString:interfaceStr headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
            
            _certainButton.userInteractionEnabled = YES;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
            
            [self dealWithLoginRegisterRequestData:dic type:type openid:openid nickName:nickName isOld:YES];
            
        } failure:^(NSError *error, NSURLSessionTask *task) {
            
            _certainButton.userInteractionEnabled = YES;
            [DLLoading DLToolTipInWindow:@"注册失败"];
            
        }];
    }    
}

-(void)dealWithLoginRegisterRequestData:(NSDictionary *)dic type:(NSString *)type openid:(NSString *)openid nickName:(NSString *)nickName isOld:(BOOL)isOld{
    
    if ([dic[@"code"] integerValue] != 0 && [dic[@"code"] integerValue] != 1) {
        NSString *tipMessage;
        if (isOld == YES) {
            tipMessage = dic[@"msg"];
        } else {
            tipMessage = dic[@"message"];
        }
        NSString *errorStr = [NSString stringWithFormat:@"%@,%@",dic[@"code"],tipMessage];

        
  
    }else{
        NSArray *keyArray=[dic allKeys];
        for (NSString *keyStr in keyArray) {
//            if ([keyStr isEqualToString:@"code"]) {
//
//                [defaults setObject:[ToolHelper getNowDate] forKey:USER_FIRST_TIME_LOGIN];
//                [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALHOLDLIST"];//清除持仓表中的
//                if ([TradeScnoManage registerIsExist]) {//不是游客
//                    if ([dic[@"code"] isEqualToString:@"0"]) {//新用户
//
//                        NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
//                        [userDe setObject:@"新用户" forKey:@"不是游客新用户"];
//                        [userDe synchronize];
//
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALSCANSTOCK"];//浏览过的股票
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_SEARCHHISTORYSTOCK"];//历史自选股票
//
//                        [self optionalStockType:type openid:openid nickName:nickName];//存用户表
//                        //清除所有的存储本地的数据
//                        [UserDefaultsOptional clearAllUserDefaultsData];
//                        //清除本地数据库中的自选股
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALLIST"];
//
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALNEWS"];
//
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"mySearchAddNotificationName" object:nil userInfo:@{@"type":@"new"}];
//                        [self registerViewJumpVcType:type];
//
//                    }else if ([dic[@"code"] isEqualToString:@"1"]){//已有用户
//
//                        NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
//                        [userDe setObject:@"已有用户" forKey:@"不是游客已有用户"];
//                        [userDe synchronize];
//
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALSCANSTOCK"];
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_SEARCHHISTORYSTOCK"];
//
//                        [self optionalStockType:type openid:openid nickName:nickName];//存用户表
//
//                        //本地删除，云端下载
//                        [[OptionalStockHandle getInstance] downServerFromYun:^(BOOL OKData) {
//
//                            if (OKData) {
//                                [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALNEWS"];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"mySearchAddNotificationName" object:nil userInfo:@{@"type":@"new"}];
//
//                                [self registerViewJumpVcType:type];
//                            }
//
//                        }];
//
//                    }
//                }else{//是游客
//                    if ([dic[@"code"] isEqualToString:@"0"]) {//新用户
//                        [self optionalStockType:type openid:openid nickName:nickName];//存用户表
//                        [self serverOptional];//自选股上传后台
//
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALSCANSTOCK"];//浏览过的股票
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_SEARCHHISTORYSTOCK"];//历史自选股票
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALNEWS"];
//
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"mySearchAddNotificationName" object:nil userInfo:@{@"type":@"new"}];
//                        [self registerViewJumpVcType:type];
//
//                    }else if ([dic[@"code"] isEqualToString:@"1"]){//已有用户
//
//                        NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
//                        [userDe setObject:@"已有用户" forKey:@"是游客已有用户"];
//                        [userDe synchronize];
//
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALSCANSTOCK"];
//                        [HQ_SetDataAgent clearDataWithName:@"PUB_SEARCHHISTORYSTOCK"];
//
//                        [self optionalStockType:type openid:openid nickName:nickName];//存用户表
//
//                        //本地删除，云端下载
//                        [[OptionalStockHandle getInstance] downServerFromYun:^(BOOL OKData) {
//
//                            if (OKData) {
//                                [HQ_SetDataAgent clearDataWithName:@"PUB_OPTIONALNEWS"];
//                                // 发送通知的代码如下：
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"mySearchAddNotificationName" object:nil userInfo:@{@"type":@"new"}];
//                                [self registerViewJumpVcType:type];
//
//
//                            }
//
//                        }];
//
//                    }
//                }
//            }
        }
    }


}

#pragma mark ✨✨✨ 修改用户表 ✨✨✨
//-(void)optionalStockType:(NSString *)type openid:(NSString *)openid nickName:(NSString *)nickName{
//    /*****在注册成功之后，需要记录当前的状态****/
//    if ([ToolHelper isBlankString:type]) {
//        NSLog(@"注册时，注册类型不可为空");
//    }
//    
////    [[SessionLose getInstance] exitLogin];
////    [[SessionLose getInstance] creditExitLogin];
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    if ([type isEqualToString:@"1"]){//手机注册用户
//        [dic setObject:phoneField.text forKey:@"SCNO"];
//        [dic setObject:[ToolHelper jiaPlusmi:phoneField.text] forKey:@"MOBILE"];
//        [dic setObject:phoneField.text forKey:@"PICKNAME"];
//        
//    }else if([type isEqualToString:@"3"]){
//        [dic setObject:openid?openid:@"" forKey:@"SCNO"];
//        [dic setObject:@"" forKey:@"MOBILE"];
//        [dic setObject:nickName?nickName:@"" forKey:@"PICKNAME"];
//    }else{
//        NSLog(@"注册账号类型即不是1，也不是3，出事情了");
//    }
//    [dic setObject:type forKey:@"TYPESCNO"];
//    [dic setObject:@"0" forKey:@"ISREGISTER"];//0 表示已经注册
//    [dic setObject:@"" forKey:@"TRADESCNO"];//交易账号清空
//    [dic setObject:@"" forKey:@"CREDITALLACCOUNTS"];//信用交易账号清空
//    
//    [DB_SetElement_PubUser setElement_Pubuser:dic];
//
//    // 如果是手机号注册用户, 则配置通达信手机号, 并且登录通达信, 其它用户郑国辉说不考虑 2017-09-20
//    if ([type isEqualToString:@"1"]) {
//        //先退出
//       
//    }
//}
#pragma mark ✨✨✨ 注册成功跳转页面 ✨✨✨
-(void)registerViewJumpVcType:(NSString *)type{
    
    __block TYAlertController *aalertController;
    TradeErrorAlertView * alertView = [[TradeErrorAlertView alloc] initTitle:@"注册成功" clickTrueBlock:^{
        registerType block = _RegisterType;
        if ([type isEqualToString:@"3"]) {
            if (block) {
                _RegisterType(@"WeChat");
            }
        } else if ([type isEqualToString:@"1"]) {
            if (block) {
                _RegisterType(@"phoneNumber");
            }
        }
        [aalertController dismissViewControllerAnimated:YES];
    
    }];
    aalertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    aalertController.backgoundTapDismissEnable = NO;
    [self presentViewController:aalertController animated:YES completion:nil];
}

#pragma mark ✨✨✨ 自选股上传后台 ✨✨✨
//-(void)serverOptional{
//    NSMutableArray *optionalArray=[NSMutableArray array];
//    NSArray *searchArray=[HQ_QueryAgent queryDataConditionTable:@"PUB_OPTIONALLIST"];//自选股数据库
//    if (searchArray.count>0) {
//        for (int i = (int)(searchArray.count - 1); i >= 0; i--) {
//            NSDictionary *dic=searchArray[i];
//            GetPriceToListModel *model;
//            model = [[GetPriceToListModel alloc] init];
//            model.name = dic[@"NAME"];
//            model.code = dic[@"STOCKCODE"];
//            model.date = dic[@"DATE"];
//            model.index = dic[@"INDEXS"];
//            model.currentPrice = dic[@"CURRENTPRICE"];
//            model.beforeClosePrice = dic[@"BEFORECLOSEPRICE"];
//            model.chg=dic[@"CHG"];
//            model.chgValue=dic[@"CHGVALUE"];
//            [optionalArray addObject:model];
//        }
//        [[OptionalStockHandle getInstance] saveServiceOptionalStock:optionalArray and:^(NSString *result,NSString *code) {
//            [DLLoading DLToolTipInWindow:result];
//        }];
//    }
//
//}

#pragma mark ✨✨✨ 退出键盘 ✨✨✨
-(void)quitKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ✨✨✨ dealloc ✨✨✨
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([messageTimer isValid]) {
        [messageTimer invalidate];
        messageTimer=nil;
    }
    
    if ([voiceTimer isValid]) {
        [voiceTimer invalidate];
        voiceTimer=nil;
    }
}


@end
