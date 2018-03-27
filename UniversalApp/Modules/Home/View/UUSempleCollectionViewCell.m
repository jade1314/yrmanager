//
//  UUSempleCollectionViewCell.m
//  UniversalApp
//
//  Created by 王玉 on 2018/3/27.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUSempleCollectionViewCell.h"

@interface UUSempleCollectionViewCell ()
@property (nonatomic, strong) UIButton *imageBtn;

@end


@implementation UUSempleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = random_color;
        _imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, self.width - 40, self.height - 40)];
        _imageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_imageBtn setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
        [self addSubview:_imageBtn];
    }
    return self;
}


- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    [_imageBtn setTitle:dataDict[@"title"] forState:UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:dataDict[@"image"]] forState:UIControlStateNormal];
    
}

@end
