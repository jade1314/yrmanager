//
//  TradeErrorAlertView.m
//  PanGu
//
//  Created by jade on 16/8/23.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "TradeErrorAlertView.h"

@interface TradeErrorAlertView()

@property (nonatomic, copy) NSString *phoneStr;

@end

@implementation TradeErrorAlertView

- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock {
    if (self = [super init]) {
        
        _title = title;
        _rect = [_title boundingRectWithSize:CGSizeMake(kScreenWidth - 80 - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        self.frame = CGRectMake(0, 0, kScreenWidth - 80, _rect.size.height + 155 + 13 + (_rect.size.height / 13 * 6));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        _clickTrueBlock = clickTrueBlock;
        [self customView];
    }
    return self;
}

- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock clickFalseBlock:(clickFalseBlock)clickFalseBlock {
    if (self = [super init]) {
        
        _title = title;
        
        _rect = [_title boundingRectWithSize:CGSizeMake(kScreenWidth - 80 - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        _title = [_title stringByAppendingString:@"\n(如有疑问, 请致电客服: 95397)"];
        _rect.size.height += 20;
        
        self.frame = CGRectMake(0, 0, kScreenWidth - 80, _rect.size.height + 155 + 13 + (_rect.size.height / 13 * 6));//(0, 0, kScreenWidth - 80, 147);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        _clickTrueBlock = clickTrueBlock;
        _clickFalseBlock = clickFalseBlock;
        [self customViewNew];
    }
    return self;
}

- (id)initTitle:(NSString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock clickFalseBlock:(clickFalseBlock)clickFalseBlock isTrade:(BOOL)isTrade {
    if (self = [super init]) {
        
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentJustified;  //最后一行自然对齐
        paraStyle01.headIndent = 0.0f;//行首缩进
        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
//        CGFloat emptylen = 15 * 2;
//        paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
        paraStyle01.tailIndent = 0.0f;//行尾缩进
        paraStyle01.lineSpacing = 3.0f;//行间距
        
        title = [[title componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n      "];
        title = [@"      " stringByAppendingString:title];
        _title = [title stringByAppendingString:@"\n\n(如有疑问, 请致电客服: 95397)"];
        
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:_title attributes:@{NSParagraphStyleAttributeName:paraStyle01,NSForegroundColorAttributeName:COLOR_DARKGREY,NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        NSRange range = NSMakeRange(0, 0);
        NSInteger length = 0;
        for (NSInteger i = _title.length - 1; i >= 0; i--) {
            if ([self checkNumber:[_title substringWithRange:NSMakeRange(i, 1)]]) {
                if (range.location == 0) {
                    range.location = i;
                }
                length++;
                range.length = length;
            }else {
                if (range.length != 0) {
                    break;
                }
            }
        }
        range = NSMakeRange(range.location-range.length+1, range.length);

        
        [attrText setAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                          NSForegroundColorAttributeName: COLOR_BLUE,
                                          NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:range];

        
        _rect = [_title boundingRectWithSize:CGSizeMake(kScreenWidth - 80 - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        _rect.size.height += 20;
        
        self.frame = CGRectMake(0, 0, kScreenWidth - 80, _rect.size.height + 155 + 13 + (_rect.size.height / 13 * 6));//(0, 0, kScreenWidth - 80, 147);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        _clickTrueBlock = clickTrueBlock;
        _clickFalseBlock = clickFalseBlock;
        [self customViewNew];
        
        _detailLabel.attributedText = attrText;
    }
    return self;
}

- (id)initAttributeTitle:(NSMutableAttributedString *)title clickTrueBlock:(clickTrueBlock)clickTrueBlock{
    if (self = [super init]) {
        _attributeTitle = title;
        _title = [title string];
        _rect =  [_title boundingRectWithSize:CGSizeMake(kScreenWidth - 80 - 60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        [_attributeTitle appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n(如有疑问, 请致电客服: 95397)"]];
        
        self.frame = CGRectMake(0, 0, kScreenWidth - 80, _rect.size.height + 155 + 13 + (_rect.size.height / 13 * 6));//(0, 0, kScreenWidth - 80, _rect.size.height + 155 + 13 + (_rect.size.height / 13 * 6));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        _clickTrueBlock = clickTrueBlock;
        [self customView];
    }
    return self;
}

- (void)customView {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 60)];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"提示";
    _titleLabel.textColor = COLOR_DARKGREY;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _titleLabel.bottom, self.width - 60, _rect.size.height + 13 + (_rect.size.height / 13 * 6) + 6)];
    _detailLabel.numberOfLines = 0;
    
    
    
    // 调整行间距
    NSMutableAttributedString *attributedString;
    if (_attributeTitle.length > 0) {
        _detailLabel.attributedText = _attributeTitle;
        attributedString = _attributeTitle;
    }else{
        _title = [_title stringByAppendingString:@"(如有疑问, 请致电客服: 95397)"];
        _detailLabel.text = _title;
        attributedString = [[NSMutableAttributedString alloc] initWithString:_title];
    }
    
    NSRange range = NSMakeRange(0, 0);
    NSInteger length = 0;
    for (NSInteger i = _title.length - 1; i >= 0; i--) {
        if ([self checkNumber:[_title substringWithRange:NSMakeRange(i, 1)]]) {
            if (range.location == 0) {
                range.location = i;
            }
            length++;
            range.length = length;
        }else {
            if (range.length != 0) {
                break;
            }
        }
    }
    range = NSMakeRange(range.location-range.length+1, range.length);
    
    _phoneStr = [_title substringWithRange:range];
    
    _detailLabel.textColor = COLOR_DARKGREY;
    _detailLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_detailLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    if (_attributeTitle.length > 0) {
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _attributeTitle.length)];
    }else{
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _title.length)];
    }
    
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                      NSForegroundColorAttributeName: COLOR_BLUE,
                                      NSFontAttributeName : [UIFont systemFontOfSize:13.0]} range:range];
    
//    [attributedString addAttribute:NSLinkAttributeName
//                             value:@"tel:95595"
//                             range:range];
    
    _detailLabel.attributedText = attributedString;
    
    _detailLabel.userInteractionEnabled = YES;
    
    UIControl *phoneControl = [[UIControl alloc] initWithFrame:[self boundingRectForCharacterRange:range andContentStr:_title]];
    [phoneControl addTarget:self action:@selector(phoneLink) forControlEvents:UIControlEventTouchUpInside];
    [_detailLabel addSubview:phoneControl];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 70, self.width, KSINGLELINE_WIDTH)];
    [self addSubview:_lineView];
    _lineView.backgroundColor = COLOR_LINE;
    
    _trueButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _trueButton.frame = CGRectMake(0, _lineView.bottom + 22, 110, 30);
    _trueButton.center = CGPointMake(self.center.x, _trueButton.center.y);
    [self addSubview:_trueButton];
    [_trueButton setTitle:@"确定" forState:(UIControlStateNormal)];
    _trueButton.backgroundColor = COLOR_BLUE;
    [_trueButton addTarget:self action:@selector(trueClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    _trueButton.layer.masksToBounds = YES;
    _trueButton.layer.cornerRadius = 2;
}

- (void)customViewNew {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.width, 18)];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"提示";
    _titleLabel.textColor = COLOR_DARKGREY;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _titleLabel.bottom + 13, self.width - 60, _rect.size.height + 13 + (_rect.size.height / 13 * 6) + 6)];
    _detailLabel.numberOfLines = 0;

    // 调整行间距
    
    
//    _detailLabel.text = _title;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_title];

    
    NSRange range = NSMakeRange(0, 0);
    NSInteger length = 0;
    for (NSInteger i = _title.length - 1; i >= 0; i--) {
        if ([self checkNumber:[_title substringWithRange:NSMakeRange(i, 1)]]) {
            if (range.location == 0) {
                range.location = i;
            }
            length++;
            range.length = length;
        }else {
            if (range.length != 0) {
                break;
            }
        }
    }
    range = NSMakeRange(range.location-range.length+1, range.length);
    
    _phoneStr = [_title substringWithRange:range];
    
    _detailLabel.textColor = COLOR_DARKGREY;
    _detailLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:_detailLabel];
     [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_DARKGREY range:NSMakeRange(0, _title.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _title.length)];
    
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                      NSForegroundColorAttributeName: COLOR_BLUE,
                                      NSFontAttributeName : [UIFont systemFontOfSize:15]} range:range];
    
    
    _detailLabel.attributedText = attributedString;
    CGRect rect = _detailLabel.frame;
    rect.size.height = rect.size.height + 20;
    _detailLabel.frame = rect;
    _detailLabel.userInteractionEnabled= YES;
    
    UIControl *phoneControl = [[UIControl alloc] initWithFrame:CGRectMake(_detailLabel.width/2, _detailLabel.height/2, _detailLabel.width/2, _detailLabel.height/2)];//[self boundingRectForCharacterRange:range andContentStr:_title]];
    [phoneControl addTarget:self action:@selector(phoneLink) forControlEvents:UIControlEventTouchUpInside];
    [_detailLabel addSubview:phoneControl];


    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 70, self.width, KSINGLELINE_WIDTH)];
    [self addSubview:_lineView];
    _lineView.backgroundColor = COLOR_LINE;
    
    _trueButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _trueButton.frame = CGRectMake(0, _lineView.bottom + 22, (self.width - 60)/2, 30);
    _trueButton.right = self.width - 20;
    [self addSubview:_trueButton];
    [_trueButton setTitle:@"确定" forState:(UIControlStateNormal)];
    _trueButton.backgroundColor = COLOR_BLUE;
    [_trueButton addTarget:self action:@selector(trueClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    _trueButton.layer.masksToBounds = YES;
    _trueButton.layer.cornerRadius = 2;
    
    _falseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _falseButton.frame = CGRectMake(0, _lineView.bottom + 22, (self.width - 60)/2, 30);
    _falseButton.left = 20;
    [self addSubview:_falseButton];
    [_falseButton setTitle:@"取消" forState:(UIControlStateNormal)];
    _falseButton.backgroundColor = COLOR_BACK;
    [_falseButton setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
    [_falseButton addTarget:self action:@selector(falseClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    _falseButton.layer.masksToBounds = YES;
    _falseButton.layer.cornerRadius = 2;
}

- (BOOL)checkNumber:(NSString *)line

{
    
    NSString *regex = @"[0-9]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:line];
    
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}

- (void)trueClicked:(UIButton *)btn {
    if (_clickTrueBlock) {
        _clickTrueBlock();
    }
}

- (void)falseClicked:(UIButton *)btn{
    if (_clickFalseBlock) {
        _clickFalseBlock();
    }
}

- (void)phoneLink {
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneStr];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phone]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

#pragma mark-<获取电话号码的坐标>
- (CGRect)boundingRectForCharacterRange:(NSRange)range andContentStr:(NSString *)contentStr
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _title.length)];
    
    NSDictionary *attrs =@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]};
    [attributeString setAttributes:attrs range:NSMakeRange(0, contentStr.length)];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:_detailLabel.size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
    
    rect.origin.y = _detailLabel.height-13;
    
    return rect;
}



@end
