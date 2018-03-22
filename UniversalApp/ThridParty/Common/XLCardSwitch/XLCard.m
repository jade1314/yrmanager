//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCard.h"

@interface XLCard () {
    UILabel *_textLabel;
}
@end

@implementation XLCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.textColor = COLOR_YELLOW;
    _textLabel.font = [UIFont boldSystemFontOfSize:24];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
}

-(void)setTitle:(NSString *)title {
    _title = title;
    _textLabel.text = title;
}

@end
