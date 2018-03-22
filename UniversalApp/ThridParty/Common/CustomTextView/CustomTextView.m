//
//  CustomTextView.m
//  PanGu
//
//  Created by jade on 16/6/20.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "CustomTextView.h"


@interface CustomTextView ()
{
    CGFloat textViewHeight;
}

@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextView];
    }
    return self;
}

- (void)setTextView
{
    self.adaptiveHeight = NO;
    self.maxNumberOfLine = 0;
    self.maxNumberOfWords = 0;
    textViewHeight = self.frame.size.height;
    // Initialization code
    //占位字符
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, self.frame.size.width, 0)];
    self.placeLabel.numberOfLines = 0;
    self.placeLabel.textColor = [UIColor grayColor];
    self.placeLabel.contentMode = UIViewContentModeTop;
    [self addSubview:self.placeLabel];
    //字数
    self.numberOfText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 18)];
    self.numberOfText.font = [UIFont systemFontOfSize:15];
    self.numberOfText.textAlignment = NSTextAlignmentRight;
    self.numberOfText.hidden = YES;
    [self addSubview:self.numberOfText];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing)  name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange)  name:UITextViewTextDidChangeNotification object:nil];
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing)  name:UITextViewTextDidEndEditingNotification object:nil];
    
}


//- (void)textViewDidBeginEditing
//{
//    self.placeLabel.text = @"";
//}

//textView文字发生变化会发出通知会调用这个方法
- (void)textViewDidChange
{
    if (self.text.length == 0) {
        self.placeLabel.text = self.placeHolder;
    }else{
        self.placeLabel.text = @"";
    }
    if (self.adaptiveHeight) {
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentSize.height);
        [self textViewChangeHeight];
    }
}

//textView文字发生变化会调用这个方法
- (void)textViewChangeHeight
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(self.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize  contentsize = CGSizeMake(0, 0);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil];
        contentsize =[self.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
        contentsize = [self.text  sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    }
    CGFloat height = contentsize.height;
    if (height > textViewHeight) {
        if (self.maxNumberOfLine == 0) {
            if (self.maxNumberOfWords != 0) {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height + 16);
            }
        }else{
            CGSize size = CGSizeMake(0, 0);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil];
                size = [self.text sizeWithAttributes:tdic];
            } else if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
                size = [self.text sizeWithFont:self.font];
            }
            //2. 取出文字的高度
            int length = size.height;
            //3. 计算行数
            int colomNumber = height/length;
            if (colomNumber <= self.maxNumberOfLine) {//限制最多显示几行
                if (self.maxNumberOfWords != 0) {
                    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height + 16);
                }
            }else{
                
            }
        }
        
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeLabel.text = placeHolder;
    [self.placeLabel sizeToFit];
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeLabel.font = font;
}

//frame,字体大小,字体颜色,背景颜色,占位字符,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor BackgroundColor:(UIColor *)backgroundcolor PlaceHolder:(NSString *)placeHolder Delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextView];
        self.font = font;
        self.textColor = textcolor;
        self.backgroundColor = backgroundcolor;
        self.placeHolder = placeHolder;
        self.delegate = delegate;
        
    }
    return self;
}



//frame,字体大小,字体颜色,背景颜色,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor BackgroundColor:(UIColor *)backgroundcolor Delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextView];
        self.font = font;
        self.textColor = textcolor;
        self.backgroundColor = backgroundcolor;
        self.delegate = delegate;
    }
    return self;
}


//frame,字体大小,字体颜色,占位字符,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor PlaceHolder:(NSString *)placeHolder Delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextView];
        self.font = font;
        self.textColor = textcolor;
        self.placeHolder = placeHolder;
        self.delegate = delegate;
    }
    return self;
}


//frame,字体大小,字体颜色,代理
- (id)initWithFrame:(CGRect)frame Font:(UIFont *)font TextColor:(UIColor *)textcolor Delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextView];
        self.font = font;
        self.textColor = textcolor;
        self.delegate = delegate;
    }
    return self;
}

@end
