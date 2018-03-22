//
//  UICardView_Cell.m
//  PanGu
//
//  Created by jade on 16/6/30.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "UICardView_Cell.h"

@implementation UICardView_Cell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        
        _label.backgroundColor = [UIColor yellowColor];
        
        _label.textColor = [UIColor redColor];
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
