//
//  TradeLoginStartViewController.m
//  PanGu
//
//  Created by Fll on 16/8/17.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "TradeLoginStartViewController.h"
#import "HttpRequest.h"
#import "UsersModel.h"
//#import "NetworkRequest.h"
//#import "Unikey.h"
#import "OpenUDID.h"
//#import "TradeLoginViewController.h"
//#import "PanGu-Swift.h"
//#import "MyAttributedStringBuilder.h"
//#import "InfoCalculate.h"
//#import "WXLLabel.h"

#define messageVerifyTime   @"120"
#define voiceVerifyTime     @"120"
#define COLOR_LIGHT_GREEN [ToolHelper colorWithHexString:@"#8cc740"]

@interface TradeLoginStartViewController ()<UITextFieldDelegate>
{
    UIView *phoneView;
    UIView *verifyView;
    UIView *picVerifyView;//输入图片验证码的底板

    UIButton *_certainButton;
    UIButton *verifyBtn;//获取验证码按钮
    
    NSTimer *messageTimer;
    NSInteger messageTick;
    NSTimer *voiceTimer;
    NSInteger voiceTick;
    
    UITextField *verifyField;
    UITextField *phoneField;
    UITextField *picVerifyField;//图片验证码输入框

    
    NSString *phoneStr;
    NSString *messageVerifyStr;
    NSString *voiceVerifyStr;
    NSString *picVerifyStr;//图片字符串

    BOOL getVerify;//判断是否点击获取验证码
    BOOL res;//判断是否注册
    BOOL isGetVerify;//获取验证码是否成功
    BOOL isVoice;//是否是语音验证码

}

@property (nonatomic, strong) UIButton *picVerifyButton;//图片验证码按钮
@property (nonatomic, strong) UIButton *messageVerifyButton;
@property (nonatomic, strong) UIButton *voiceVerifyButton;
@property (nonatomic, strong) UIView *voiceVerifyBottomView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TradeLoginStartViewController

#pragma mark ✨✨✨ viewWillDisappear ✨✨✨
-(void)viewWillDisappear:(BOOL)animated{
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

#pragma mark ✨✨✨ viewDidLoad ✨✨✨
- (void)viewDidLoad {
    [super viewDidLoad];

    //判断是否注册???

    self.navigationItem.title = @"手机验证";

    getVerify=NO;
    phoneView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 50)];
    phoneView.backgroundColor=[UIColor whiteColor];
    phoneView.layer.cornerRadius = 5;
    [self.view addSubview:phoneView];
    
    UIButton *LeftPhoneButton=[[UIButton alloc] init];
    [LeftPhoneButton setImage:[UIImage imageNamed:@"shoujichuce"] forState:UIControlStateNormal];
    LeftPhoneButton.frame=CGRectMake(17, (50-19)/2, 15, 19);
    LeftPhoneButton.userInteractionEnabled=NO;
    [phoneView addSubview:LeftPhoneButton];
    
    UIButton *phoneButton=[[UIButton alloc] initWithFrame:CGRectMake(LeftPhoneButton.right+8, 0, 25, 50)];
    [phoneButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    phoneButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [phoneButton setTitle:@"+86" forState:UIControlStateNormal];
    phoneButton.userInteractionEnabled=NO;
    [phoneView addSubview:phoneButton];
    
    UIView *lineView=[[UIView alloc] init];
    lineView.frame=CGRectMake(72-KSINGLELINE_WIDTH, (50-20)/2, KSINGLELINE_WIDTH, 20);
    lineView.backgroundColor=COLOR_LINE;
    [phoneView addSubview:lineView];
    
    phoneField=[[UITextField alloc] initWithFrame:CGRectMake(lineView.right+10, 0, phoneView.width-90, 50)];
    phoneField.borderStyle=UITextBorderStyleNone;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    phoneField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    phoneField.tintColor=COLOR_BLUE;
    phoneField.tag=103400;
    phoneField.placeholder=@"请输入手机号";
    phoneField.delegate = self;
    phoneField.font=[UIFont systemFontOfSize:15];
    [phoneView addSubview:phoneField];
    
    //输入框点击响应事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTradeDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    picVerifyView=[[UIView alloc] initWithFrame:CGRectMake(20, 20+50+20, 160-20+50, 50)];
    picVerifyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:picVerifyView];
    picVerifyView.layer.cornerRadius = 5;
    
    UIButton *picLeftVerifyButton=[[UIButton alloc] init];
    [picLeftVerifyButton setImage:[UIImage imageNamed:@"identifyingcode"] forState:UIControlStateNormal];
    picLeftVerifyButton.frame=CGRectMake(17, (50-15)/2, 15, 15);
    picLeftVerifyButton.userInteractionEnabled=NO;
    [picVerifyView addSubview:picLeftVerifyButton];
    
    picVerifyField=[[UITextField alloc] initWithFrame:CGRectMake(picLeftVerifyButton.right+12, 0, picVerifyView.width-40, 50)];
    picVerifyField.borderStyle=UITextBorderStyleNone;
    picVerifyField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    picVerifyField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    picVerifyField.tintColor=COLOR_BLUE;
    picVerifyField.tag=103402;
    picVerifyField.placeholder=@"请输入验证码";
    picVerifyField.delegate = self;
    picVerifyField.font=[UIFont systemFontOfSize:15];
    [picVerifyView addSubview:picVerifyField];
    
    CGFloat picVerifyWidth = (kScreenWidth-picVerifyView.right-20-10);
    _picVerifyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _picVerifyButton.frame = CGRectMake(picVerifyView.right + 10 + 20, phoneView.bottom + 20 + (50 - 35)/2, picVerifyWidth - 40, 35);
    _picVerifyButton.backgroundColor=[UIColor clearColor];
    [_picVerifyButton setTitle:@"" forState:UIControlStateNormal];
    [_picVerifyButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    _picVerifyButton.adjustsImageWhenHighlighted = NO;
    
    [_picVerifyButton addTarget:self action:@selector(clickPicVerifyButton:) forControlEvents:UIControlEventTouchUpInside];
    _picVerifyButton.layer.borderColor = COLOR_LINE.CGColor;
    _picVerifyButton.layer.borderWidth = KSINGLELINE_WIDTH;
    _picVerifyButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _picVerifyButton.tag = 94602;
    [self.view addSubview:_picVerifyButton];
    
    
    
    verifyView=[[UIView alloc] initWithFrame:CGRectMake(20, 20+(50+20)*2, 160-20+50, 50)];
    verifyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:verifyView];
    verifyView.layer.cornerRadius = 5;
    
    UIButton *LeftVerifyButton=[[UIButton alloc] init];
    [LeftVerifyButton setImage:[UIImage imageNamed:@"suozhuce"] forState:UIControlStateNormal];
    LeftVerifyButton.frame=CGRectMake(17, (50-15)/2, 15, 15);
    LeftVerifyButton.userInteractionEnabled=NO;
    [verifyView addSubview:LeftVerifyButton];
    
    verifyField=[[UITextField alloc] initWithFrame:CGRectMake(LeftVerifyButton.right+12, 0, verifyView.width-40, 50)];
    verifyField.borderStyle=UITextBorderStyleNone;
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;//叉号
    verifyField.keyboardType=UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
    verifyField.tintColor=COLOR_BLUE;
    verifyField.tag=103401;
    verifyField.placeholder=@"请输入6位验证码";
    verifyField.delegate = self;
    verifyField.font=[UIFont systemFontOfSize:15];
    [verifyView addSubview:verifyField];
    
    CGFloat messageVerifyWidth = (kScreenWidth-verifyView.right-20-10);
    _messageVerifyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _messageVerifyButton.frame = CGRectMake(verifyView.right + 10, picVerifyView.bottom + 20, messageVerifyWidth, 50);
    _messageVerifyButton.backgroundColor=COLOR_LIGHT_GREEN;
    [_messageVerifyButton setTitle:@"短信验证码" forState:UIControlStateNormal];
    [_messageVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_messageVerifyButton addTarget:self action:@selector(getVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    _messageVerifyButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _messageVerifyButton.layer.cornerRadius = 5;
    _messageVerifyButton.layer.masksToBounds = YES;
    _messageVerifyButton.tag = 94600;
    [self.view addSubview:_messageVerifyButton];
    _certainButton=[[UIButton alloc] initWithFrame:CGRectMake(20, verifyView.bottom + 35, kScreenWidth-40, 50)];//60
    _certainButton.backgroundColor=[ToolHelper colorWithHexString:@"b3b3b3"];
    [_certainButton setTitle:@"手机号验证" forState:UIControlStateNormal];
    [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [_certainButton addTarget:self action:@selector(registerStartClick) forControlEvents:UIControlEventTouchUpInside];
    _certainButton.userInteractionEnabled=NO;
    _certainButton.layer.cornerRadius=5;
    [self.view addSubview:_certainButton];
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _certainButton.bottom + 20, kScreenWidth - 40, 40)];
    _tipLabel.numberOfLines = 0;
    NSString *str = @"联系客服";
    _tipLabel.text = [NSString stringWithFormat:@"温馨提示%@",str];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.userInteractionEnabled = YES;
    _tipLabel.textColor = COLOR_LIGHTGRAY;
    NSRange range = NSMakeRange(_tipLabel.text.length - str.length - 1, str.length);
    
    UIControl *control = [[UIControl alloc]initWithFrame:[self boundingRectForCharacterRange:range andContentStr:_tipLabel.text]];
    [control addTarget:self action:@selector(clickAgreement) forControlEvents:UIControlEventTouchUpInside];
    [_tipLabel addSubview:control];
    [self.view addSubview:_tipLabel];
    [self createVoiceView];
    [self requestPicVerify];
    
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range andContentStr:(NSString *)contentStr
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentStr.length)];
    
    NSDictionary *attrs =@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    [attributeString setAttributes:attrs range:NSMakeRange(0, contentStr.length)];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:_tipLabel.size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    
    rect.origin.y = _tipLabel.height - 14 - 5;
    
    return rect;
}


- (void)clickAgreement {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006505999"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    });
}

- (void)clickPicVerifyButton:(UIButton *)sender {
    [self requestPicVerify];
}

#pragma mark  请求图片验证码
- (void)requestPicVerify {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[OpenUDID value] forKey:@"equipment"];
    
    [[HttpRequest getInstance] getWithURLString:@"" headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        //
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        
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
        //
        
        NSLog(@"%@",[error localizedDescription]);
        [_picVerifyButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [_picVerifyButton setTitle:@"重新获取" forState:UIControlStateNormal];
        
        
    }];
    
}


#pragma mark ✨✨✨ 创建语音验证码view ✨✨✨
- (void)createVoiceView {
    _voiceVerifyBottomView = [[UIView alloc]initWithFrame:CGRectMake(20, _tipLabel.bottom + 20, kScreenWidth - 40, 35)];
    _voiceVerifyBottomView.layer.cornerRadius = 5;
    _voiceVerifyBottomView.layer.borderWidth = KSINGLELINE_WIDTH;
    _voiceVerifyBottomView.layer.borderColor = COLOR_RED.CGColor;
    [self.view addSubview:_voiceVerifyBottomView];
    _voiceVerifyBottomView.hidden = YES;
    
    CGSize  voiceLabelSize = [ToolHelper sizeForNoticeTitle:@"如果没收到短信验证码，请您尝试" font:[UIFont systemFontOfSize:14]];
    CGSize  voiceButtonTextSize = [ToolHelper sizeForNoticeTitle:@"语音验证码" font:[UIFont systemFontOfSize:14]];
    CGFloat leftX = (kScreenWidth - 40 - (13 + 6 + voiceLabelSize.width + 5 + voiceButtonTextSize.width))/2;
    UIImageView *warnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftX, 0 , 13, 35)];
    warnImageView.contentMode = UIViewContentModeCenter;
    warnImageView.image = ImageNamed(@"registerWarning");
    [_voiceVerifyBottomView addSubview:warnImageView];
    
    UILabel *voiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(warnImageView.right + 6, 0, voiceLabelSize.width, 35)];
    voiceLabel.font = [UIFont systemFontOfSize:14];
    voiceLabel.text = @"如果没收到短信验证码，请您尝试";
    voiceLabel.textColor = [ToolHelper colorWithHexString:@"#808080"];
    [_voiceVerifyBottomView addSubview:voiceLabel];
    
    UIView *singleView = [[UIView alloc]initWithFrame:CGRectMake(voiceLabel.right + 5, (35)/2+voiceButtonTextSize.height/2 + 2, voiceButtonTextSize.width, KSINGLELINE_WIDTH)];
    singleView.backgroundColor = COLOR_LIGHT_GREEN;
    [_voiceVerifyBottomView addSubview:singleView];
    
    _voiceVerifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceVerifyButton.frame = CGRectMake(voiceLabel.right + 5, 0, voiceButtonTextSize.width + leftX, 35);
    [_voiceVerifyButton setTitle:@"语音验证码" forState:UIControlStateNormal];
    _voiceVerifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _voiceVerifyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_voiceVerifyButton setTitleColor:COLOR_LIGHT_GREEN forState:UIControlStateNormal];
    [_voiceVerifyBottomView addSubview:_voiceVerifyButton];
    [_voiceVerifyButton addTarget:self action:@selector(getVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    _voiceVerifyButton.tag = 94601;
}


#pragma mark ✨✨✨ 点击获取验证码 ✨✨✨
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
        
        if ([messageTimer isValid]) {
            [messageTimer invalidate];
            messageTimer=nil;
        }
        
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        
        _voiceVerifyBottomView.hidden = NO;
        _voiceVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.userInteractionEnabled = YES;
        _messageVerifyButton.backgroundColor=COLOR_LIGHT_GREEN;
        [_messageVerifyButton setTitle:@"重发短信" forState:UIControlStateNormal];
        [_messageVerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        NSString *str = [NSString stringWithFormat:@"重获短信%ld",messageTick];
        [_messageVerifyButton setTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark ✨✨✨ 计时器倒计时（语音） ✨✨✨
- (void)RegisterVoiceTimeRun {
    voiceTick--;
    if(voiceTick==0){
        
        if ([voiceTimer isValid]) {
            [voiceTimer invalidate];
            voiceTimer=nil;
        }
        
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        
        _voiceVerifyButton.userInteractionEnabled = YES;
        [_voiceVerifyButton setTitle:@"重发语音" forState:UIControlStateNormal];
        
    }else{
        NSString *str = [NSString stringWithFormat:@"重获语音%ld",voiceTick];
        [_voiceVerifyButton setTitle:str forState:UIControlStateNormal];
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

- (void)requestMessageVerify {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:phoneField.text forKey:@"phone"];
    [params setValue:verifyField.text forKey:@"auth"];
    [[HttpRequest getInstance] getWithURLString:@"" headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        //
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",result);
        NSString *code = result[@"code"];
        if ([code isEqualToString:@"200"]) {
            [self bindingPhoneNumber];
        } else {
            _certainButton.userInteractionEnabled = YES;
            [DLLoading DLToolTipInWindow:result[@"message"]];

        }
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        //
        NSLog(@"%@",[error localizedDescription]);
        _certainButton.userInteractionEnabled = YES;
        

        
        
    }];
    
}


- (void)dealRequestError:(NSString *)title buttonTag:(NSInteger)tag {
    isGetVerify=NO;
    __block TYAlertController *aalertController;
    TradeErrorAlertView * alertView = [[TradeErrorAlertView alloc] initTitle:title?title:@"" clickTrueBlock:^{
        picVerifyField.text = @"";
        verifyField.text = @"";
        [self requestPicVerify];
        [aalertController dismissViewControllerAnimated:YES];
    }];
    aalertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    aalertController.backgoundTapDismissEnable = YES;
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
        _messageVerifyButton.userInteractionEnabled = YES;
        _voiceVerifyButton.userInteractionEnabled = YES;
        [_voiceVerifyButton setTitle:@"重发语音" forState:UIControlStateNormal];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==103400) {
        phoneView.layer.borderColor=COLOR_YELLOW.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_WHITE.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_WHITE.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;
        
    }else if (textField.tag==103401){
        phoneView.layer.borderColor=COLOR_WHITE.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_YELLOW.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_WHITE.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;
    } else if (textField.tag==103402){
        phoneView.layer.borderColor=COLOR_WHITE.CGColor;
        phoneView.layer.borderWidth=KSINGLELINE_WIDTH;
        verifyView.layer.borderColor=COLOR_WHITE.CGColor;
        verifyView.layer.borderWidth=KSINGLELINE_WIDTH;
        picVerifyView.layer.borderColor = COLOR_YELLOW.CGColor;
        picVerifyView.layer.borderWidth = KSINGLELINE_WIDTH;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==103401) {
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
- (void)textFieldTradeDidChange:(NSNotification *)notification {
    
    UITextField *textField = [notification object];
    NSLog(@"%@",textField.text);
    
    if (textField.tag==103400) {
        NSLog(@"%@",textField.text);
        if (textField.text.length == 11) {
            [self quitKeyboard];
        } else if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
            [self quitKeyboard];
        }
    }else if (textField.tag==103401){
        if (textField.text.length==6) {
            [self quitKeyboard];
        } else if (textField.text.length>6) {
            textField.text=[textField.text substringWithRange:NSMakeRange(0, 6)];
            [self quitKeyboard];
        }

    } else if (textField.tag == 103402) {
        if (textField.text.length == 4) {
            [self quitKeyboard];
        } else if (textField.text.length > 4) {
            textField.text=[textField.text substringWithRange:NSMakeRange(0, 4)];
            [self quitKeyboard];
        }
    }
    
    if ((![ToolHelper isBlankString:phoneField.text])&&(![ToolHelper isBlankString:verifyField.text]) && ![ToolHelper isBlankString:picVerifyField.text]) {
        _certainButton.backgroundColor=COLOR_YELLOW;
        _certainButton.userInteractionEnabled=YES;

    }else{
        _certainButton.backgroundColor=[ToolHelper colorWithHexString:@"b3b3b3"];//COLOR_LIGHTGRAY;
        _certainButton.userInteractionEnabled=NO;
    }
}

#pragma mark ✨✨✨ 退出键盘 ✨✨✨
-(void)quitKeyboard{
    [self.view endEditing:YES];
}


#pragma mark ✨✨✨ 点击手机号验证按钮 ✨✨✨
-(void)registerStartClick{
    NSLog(@"手机号验证");
    if (![ToolHelper validateMobile:phoneField.text]){
        [DLLoading DLToolTipInWindow:@"请输入正确的手机号"];
        return;
    }

    _certainButton.userInteractionEnabled = NO;
    [self bindingPhoneNumber];

//    [self requestMessageVerify];
    
}

- (void)bindingPhoneNumber {
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:phoneField.text forKey:@"phone"];//手机号
    [params setValue:@"" forKey:@"user_account"];//账户号码
    [params setValue:@"" forKey:@"user_type"];//账户号码类型 1：手机用户2：QQ用户 3：微信用户 4：微博用户 9：其他用户
    [params setValue:[OpenUDID value] forKey:@"equipment"];//设备号
    [params setValue:verifyField.text forKey:@"auth"];//短信验证码

    
    [[HttpRequest getInstance] getWithURLString:@"" headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        _certainButton.userInteractionEnabled = YES;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:3 error:nil];
        NSLog(@"%@",dic);
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [self verifySuccess];
            
            [ToolHelper showPrompt:@"验证成功" andOriginController:self andSetBackgoundUserInteractionEnabled:NO andBlock:^{
                //进入交易界面
//                if (CreditLogin == 0) {
//                    TradeLoginViewController *tradeLoginVc=(TradeLoginViewController *)[BaseJumpClass creatTradeViewController];
//                    tradeLoginVc.fromViewController = self.fromViewController;
//                    tradeLoginVc.pushViewController = self.pushViewController;
//                    tradeLoginVc.backTradeLoginBlock = ^{
//
//                        if (_backTradeLoginStartBlock) {
//                            _backTradeLoginStartBlock();
//                        }
//
//                    };
//                    [self.navigationController pushViewController:tradeLoginVc animated:YES];
//                }else{
//                    TradeAndCreditLoginViewController *tradeLoginVc=(TradeAndCreditLoginViewController *)[BaseJumpClass creatTradeViewController];
//                    tradeLoginVc.fromViewController = self.fromViewController;
//                    tradeLoginVc.pushViewController = self.pushViewController;
//                    tradeLoginVc.loginType = self.loginType;
//                    tradeLoginVc.backTradeLoginBlock = ^{
//
//                        if (_backTradeLoginStartBlock) {
//                            _backTradeLoginStartBlock();
//                        }
//
//                    };
//                    [self.navigationController pushViewController:tradeLoginVc animated:YES];
//                }
            }];
            
        } else {
            
            [ToolHelper showPrompt:dic[@"msg"]?dic[@"msg"]:@"" andOriginController:self andSetBackgoundUserInteractionEnabled:NO andBlock:nil];
            
        }
        
        
    } failure:^(NSError *error, NSURLSessionTask *task) {
        
        _certainButton.userInteractionEnabled = YES;
        [ToolHelper showPrompt:[error localizedDescription] andOriginController:self andSetBackgoundUserInteractionEnabled:NO andBlock:nil];
        
    }];
}

#pragma mark ✨✨✨ 手机号验证成功存数据库 ✨✨✨
- (void)verifySuccess {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[ToolHelper jiaPlusmi:phoneField.text] forKey:@"MOBILE"];//手机号
    
    
    [defaults setObject:[ToolHelper getNowDate] forKey:USER_FIRST_TIME_LOGIN];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];//收起键盘
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
