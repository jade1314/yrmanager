//
//  Y_Keyboard.m
//  PanGu
//
//  Created by jade on 16/8/19.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "Y_Keyboard.h"
#import "UITextField+ExtentRange.h"

@implementation Y_Keyboard{

    NSInteger numLimit;//限制输入个数
    
    BOOL monitorSwitch;//开关

}

- (void)setTextField:(UITextField *)textField {

    [_textField removeObserver:self forKeyPath:@"text"];
    _textField = textField;
    _textField.delegate = self;
    [_textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (id)initWithFrame:(CGRect)frame textField:(UITextField *)textField shouldReturn:(shouldReturnBlock)shouldReturnBlock textChange:(textChangeBlock)textChangeBlock {
    
    if (self = [super initWithFrame:frame]) {
        numLimit = NSIntegerMax;//默认最大值
        _textField = textField;
        _textField.delegate = self;
        _textField.inputAccessoryView = [UIView new];
        [_textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        _shouldReturnBlock = shouldReturnBlock;
        _textChangeBlock = textChangeBlock;
        [self customNumberKeyboard];
        [self custom26Keyboard];
        
        [self customAllKey];
        
        _26KeyBack.hidden = YES;
        self.height += isiPhoneX ? TABBAR_X_DIF_HEIGHT : 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame textField:(UITextField *)textField andNumLimit:(NSInteger)limit shouldReturn:(shouldReturnBlock)shouldReturnBlock textChange:(textChangeBlock)textChangeBlock {
    
    if (self = [super initWithFrame:frame]) {
        numLimit = limit;
        _textField = textField;
        _textField.delegate = self;
        _textField.inputAccessoryView = [UIView new];
        [_textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        _shouldReturnBlock = shouldReturnBlock;
        _textChangeBlock = textChangeBlock;
        [self customNumberKeyboard];
        [self custom26Keyboard];
        
        [self customAllKey];
        
        _26KeyBack.hidden = YES;
    }
    return self;
}

-(void)textFieldDidChange:(NSNotification *)obj {
    
    if (_textFieldInputBlock) {
        _textFieldInputBlock(self, obj.userInfo[@"new"], obj.object);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    !_textFieldShouldBeginEditingBlock ? : _textFieldShouldBeginEditingBlock();
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    monitorSwitch = NO;
    
    if (_textFieldShouldBeginBlock) {
        _textFieldShouldBeginBlock(self, _textField);
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
    monitorSwitch = YES;
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    !_textFieldShouldClearBlock ? : _textFieldShouldClearBlock();
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSString *nowContent = change[@"new"];
    
    if (nowContent.length > numLimit) return;
    
    if (!monitorSwitch) {
        _textChangeBlock((UITextField *)object, nowContent, _textField);
    }
    
}

- (void)customAllKey {
    
    for (UIView *item in _numberBack.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            [(UIButton *)item setBackgroundImage:[UIImage getImageWithColor:COLOR_LIGHTGRAY] forState:(UIControlStateHighlighted)];
        }
    }
    for (UIView *item in _26KeyBack.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            [(UIButton *)item setBackgroundImage:[UIImage getImageWithColor:COLOR_LIGHTGRAY] forState:(UIControlStateHighlighted)];
        }
    }
}

- (void)custom26Keyboard {
    
    _lowercaseArray = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p",
                                @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l",
                                @"z", @"x", @"c", @"v", @"b", @"n", @"m"];
    _capitalArray = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P",
                              @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L",
                              @"Z", @"X", @"C", @"V", @"B", @"N", @"M"];
    
    // 创建26键View
    _26KeyBack = [[UIView alloc] initWithFrame:self.frame];
    _26KeyBack.height -= TABBAR_X_DIF_HEIGHT;
    [self addSubview:_26KeyBack];
    _26KeyBack.backgroundColor = COLOR_BACK;
    
    __block int i = 0;
    __block int j = 0;
    CGFloat width = (kScreenWidth - (5 * 11)) / 10;
    CGFloat height = (self.height - 40) / 4;
    [_lowercaseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *keyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [keyBtn setTitle:obj forState:(UIControlStateNormal)];
        keyBtn.backgroundColor = [UIColor whiteColor];
        keyBtn.tag = 7000 + idx;
        [_26KeyBack addSubview:keyBtn];
        if (idx <=9) {
            keyBtn.frame = CGRectMake((5 + width) * idx + 5, 5, width, height);
        }else if (idx > 9 && idx <=18){
            keyBtn.frame = CGRectMake((5 + width) * i + (5 + width / 2), 15 + height, width, height);
            i++;
        }else {
            keyBtn.frame = CGRectMake((5 + width) * j + (10 + width / 2 * 3), 25 + height * 2, width, height);
            j++;
        }
        [keyBtn addTarget:self action:@selector(key_26Clicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }];
    // 创建切换大小写 Btn
    UIButton *tOggleCaseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:tOggleCaseBtn];
    tOggleCaseBtn.frame = CGRectMake(5, 25 + height * 2, width * 1.5, height);
    tOggleCaseBtn.backgroundColor = COLOR_KEYBOARD;
    [tOggleCaseBtn setImage:ImageNamed(@"up-arrow") forState:(UIControlStateNormal)];
    [tOggleCaseBtn setImage:ImageNamed(@"up-arrowafter") forState:(UIControlStateSelected)];
    
    [tOggleCaseBtn addTarget:self action:@selector(tOggleCase:) forControlEvents:(UIControlEventTouchUpInside)];
    // 创建删除 Btn
    UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:deleteBtn];
    deleteBtn.frame = CGRectMake(kScreenWidth - width * 1.5 - 10, 25 + height * 2, width * 1.5 + 5, height);
    deleteBtn.backgroundColor = COLOR_KEYBOARD;
    [deleteBtn setImage:ImageNamed(@"back-arrow") forState:(UIControlStateNormal)];
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:(UIControlEventTouchUpInside)];
    // 创建切换数字英文 Btn
    UIButton *switchStyleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:switchStyleBtn];
    switchStyleBtn.frame = CGRectMake(5, self.height - 5 - height, width * 1.5, height);
    [switchStyleBtn setTitle:@"123" forState:(UIControlStateNormal)];
    switchStyleBtn.backgroundColor = COLOR_KEYBOARD;
    [switchStyleBtn addTarget:self action:@selector(switchStyle:) forControlEvents:(UIControlEventTouchUpInside)];
    // 创建收起键盘 Btn
    UIButton *packUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:packUpBtn];
    packUpBtn.frame = CGRectMake(switchStyleBtn.right + 5, switchStyleBtn.top, width * 2 + 10, switchStyleBtn.height);
    [packUpBtn setTitle:@"收起" forState:(UIControlStateNormal)];
//    [packUpBtn setImage:ImageNamed(@"xiajiantou-black") forState:(UIControlStateNormal)];
    packUpBtn.backgroundColor = COLOR_KEYBOARD;
    [packUpBtn addTarget:self action:@selector(packUp:) forControlEvents:(UIControlEventTouchUpInside)];
    // 创建空格 Btn
    UIButton *spaceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:spaceBtn];
    spaceBtn.backgroundColor = COLOR_WHITE;
    spaceBtn.frame = CGRectMake(packUpBtn.right + 5, packUpBtn.top, 4.5 * width + 10, packUpBtn.height);
    [spaceBtn setTitle:@"空格" forState:(UIControlStateNormal)];
    [spaceBtn addTarget:self action:@selector(space:) forControlEvents:(UIControlEventTouchUpInside)];
    // 创建确定 Btn
    UIButton *determineBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_26KeyBack addSubview:determineBtn];
    determineBtn.frame = CGRectMake(spaceBtn.right + 5, spaceBtn.top, width * 2 + 10, spaceBtn.height);
    determineBtn.backgroundColor = COLOR_BLUE;
    [determineBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [determineBtn setTitleColor:COLOR_WHITE forState:(UIControlStateNormal)];
    [determineBtn addTarget:self action:@selector(determine:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 改圆角
    [self roundedCorners];
    
    [determineBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}

- (void)customNumberKeyboard {
    
    NSArray *numberArray = @[@"1", @"2", @"3", @"", @"4", @"5", @"6", @"清空", @"7", @"8", @"9", @"", @"ABC", @"0", @".", @"确定"];
    NSArray *shortcutArray = @[@"600", @"601", @"000", @"002", @"300"];
    
    // 创建数字View
    _numberBack = [[UIView alloc] initWithFrame:self.frame];
    _numberBack.height -= TABBAR_X_DIF_HEIGHT;
    [self addSubview:_numberBack];
    _numberBack.backgroundColor = COLOR_BACK;
    
    CGFloat width = kScreenWidth / 5;
    CGFloat height = self.height / 4;
    [shortcutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *shortcutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_numberBack addSubview:shortcutBtn];
        shortcutBtn.frame = CGRectMake(0, (self.height / 5) * idx, width, self.height / 5);
        [shortcutBtn setTitle:obj forState:(UIControlStateNormal)];
        [shortcutBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        shortcutBtn.backgroundColor = COLOR_BACK;
        [shortcutBtn addTarget:self action:@selector(key_26Clicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }];
    [numberArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *numBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_numberBack addSubview:numBtn];
        numBtn.frame = CGRectMake(width * (idx % 4) + width, (idx / 4) * height, width, height);
        [numBtn setTitle:obj forState:(UIControlStateNormal)];
        [numBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        numBtn.backgroundColor = [UIColor whiteColor];
        [numBtn addTarget:self action:@selector(key_26Clicked:) forControlEvents:(UIControlEventTouchUpInside)];
        if (idx == 3) {
            [numBtn removeTarget:self action:@selector(key_26Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn addTarget:self action:@selector(delete:) forControlEvents:(UIControlEventTouchUpInside)];
            numBtn.backgroundColor = COLOR_BACK;
            [numBtn setImage:ImageNamed(@"back-arrow") forState:(UIControlStateNormal)];
        }
        if (idx == 7) {
            [numBtn removeTarget:self action:@selector(key_26Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn addTarget:self action:@selector(clear:) forControlEvents:(UIControlEventTouchUpInside)];
            numBtn.backgroundColor = COLOR_BACK;
        }
        if (idx == 11) {
            [numBtn removeTarget:self action:@selector(key_26Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn addTarget:self action:@selector(packUp:) forControlEvents:(UIControlEventTouchUpInside)];
            numBtn.backgroundColor = COLOR_BACK;
            [numBtn setTitle:@"收起" forState:(UIControlStateNormal)];
//            [numBtn setImage:ImageNamed(@"xiajiantou-black") forState:(UIControlStateNormal)];
        }
        if (idx == 12) {
            [numBtn removeTarget:self action:@selector(key_26Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn addTarget:self action:@selector(switchStyle26Key:) forControlEvents:(UIControlEventTouchUpInside)];
            numBtn.backgroundColor = COLOR_BACK;
        }
        if (idx == 14) {
            numBtn.backgroundColor = COLOR_BACK;
        }
        if (idx == 15) {
            [numBtn setTitleColor:COLOR_WHITE forState:(UIControlStateNormal)];

            [numBtn removeTarget:self action:@selector(key_26Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn addTarget:self action:@selector(determine:) forControlEvents:(UIControlEventTouchUpInside)];
            numBtn.backgroundColor = COLOR_BLUE;
        }
    }];
    [self addBorder];
}

- (void)clear:(UIButton *)btn {
    _textField.text = @"";
}

// 26键点击
- (void)key_26Clicked:(UIButton *)btn {
    
    NSMutableString *a_text_str = [NSMutableString stringWithFormat:@"%@",_textField.text];
    
    if (a_text_str.length > numLimit || a_text_str.length == numLimit) return;
    
    NSRange range = NSMakeRange([_textField selectedRange].location + btn.titleLabel.text.length, 0);
    
    [a_text_str insertString:btn.titleLabel.text atIndex:[_textField selectedRange].location];
    
    _textField.text = a_text_str;
    
    UITextPosition* beginning = _textField.beginningOfDocument;
    
    UITextPosition* startPosition = [_textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [_textField positionFromPosition:beginning offset:range.location];
    UITextRange* selectionRange = [_textField textRangeFromPosition:startPosition toPosition:endPosition];
    
    [_textField setSelectedTextRange:selectionRange];
}

// 切换大小写点击
- (void)tOggleCase:(UIButton *)btn {

    for (UIButton *keyBtn in _26KeyBack.subviews) {
        if (keyBtn.tag >= 7000 && keyBtn.tag <= 7025) {
            [keyBtn setTitle:btn.selected ? _lowercaseArray[keyBtn.tag - 7000] : _capitalArray[keyBtn.tag - 7000] forState:(UIControlStateNormal)];
        }
    }
    btn.selected = !btn.selected;
}

// 删除按钮点击
- (void)delete:(UIButton *)btn {
    if (_textField.text.length > 0) {
        NSMutableString *a_text_str = _textField.text.mutableCopy;
        NSInteger location = [_textField selectedRange].location - 1;
        if (location >= 0) {
            [a_text_str deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        _textField.text = a_text_str;
        
        if (location > 0) {
            NSRange range  = NSMakeRange(location, 0);
            UITextPosition* beginning = _textField.beginningOfDocument;
            
            UITextPosition* startPosition = [_textField positionFromPosition:beginning offset:range.location];
            UITextPosition* endPosition = [_textField positionFromPosition:beginning offset:range.location + range.length];
            UITextRange* selectionRange = [_textField textRangeFromPosition:startPosition toPosition:endPosition];
            
            [_textField setSelectedTextRange:selectionRange];
        }
    }
}

- (void)switchStyle26Key:(UIButton *)btn {
    _26KeyBack.hidden = NO;
}

// 切换数字英文键盘点击
- (void)switchStyle:(UIButton *)btn {
    _26KeyBack.hidden = YES;
}

// 收起键盘
- (void)packUp:(UIButton *)btn {
    [_textField resignFirstResponder];
    if (_shouldReturnBlock) {
        _shouldReturnBlock(self, _textField.text, self.textField);
    }
}

// 点击空格
- (void)space:(UIButton *)btn {
    
    NSMutableString *a_text_str = [NSMutableString stringWithFormat:@"%@",_textField.text];
    
    if (a_text_str.length > numLimit || a_text_str.length == numLimit) return;
    
    NSMutableString *text = _textField.text.mutableCopy;
    [text insertString:@" " atIndex:[_textField selectedRange].location];
    _textField.text = text;
}

// 点击确认
- (void)determine:(UIButton *)btn {
    if (_shouldReturnBlock) {
        _shouldReturnBlock(self, _textField.text, self.textField);
    }
}

- (void)addBorder {
    
    for (UIButton *keyBtn in _numberBack.subviews) {
        keyBtn.layer.borderColor = COLOR_LINE.CGColor;
        keyBtn.layer.borderWidth = KSINGLELINE_WIDTH;
    }
}

- (void)roundedCorners {
    
    for (UIButton *keyBtn in _26KeyBack.subviews) {
        [keyBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        keyBtn.layer.cornerRadius = 4;
        //keyBtn.layer.masksToBounds = YES;
        keyBtn.layer.shadowColor = COLOR_DARKBLACK.CGColor;
        keyBtn.layer.shadowOffset = CGSizeMake(0, 1);
        keyBtn.layer.shadowRadius = 1;
        keyBtn.layer.shadowOpacity= 0.5;
    }
}

//释放内存
-(void)dealloc{
    
    [_textField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
