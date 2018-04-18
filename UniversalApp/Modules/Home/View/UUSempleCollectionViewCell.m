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
        self.backgroundColor = COLOR_WHITE;
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.frame = CGRectMake(0, 0, self.width, self.height);
        _imageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_imageBtn setTitleColor:COLOR_DARKGREY forState:UIControlStateNormal];
        _imageBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageBtn];
        [_imageBtn addTapBlock:^(UIButton *btn) {
            [UIAlertController mj_showAlertWithTitle:btn.titleLabel.text message:@"正在开发中..." appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                
                alertMaker.addActionDefaultTitle(@"确认");
                
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
            }];
        }];
    }
    return self;
}


- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    UIEdgeInsets insert = [_dataDict[@"size"] UIEdgeInsetsValue];
//    _imageBtn.contentEdgeInsets = insert;
    [_imageBtn setTitle:dataDict[@"title"] forState:UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:dataDict[@"image"]] forState:UIControlStateNormal];
    _imageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
    [_imageBtn setTitleEdgeInsets: UIEdgeInsetsMake(_imageBtn.imageView.height + 5, -_imageBtn.imageView.width, 0, 0)];
    //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
    [_imageBtn setImageEdgeInsets: UIEdgeInsetsMake(-_imageBtn.titleLabel.height - 5, 0, 0, -_imageBtn.titleLabel.width)];
}

@end
