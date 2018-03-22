//
//  TableViewCell.m
//  UniversalApp
//
//  Created by JadeM on 2017/8/1.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()

@end

@implementation TableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark -  初始化UI
-(void)initUI{
    
}

#pragma mark -  渲染页面
-(void)setModel:(CellModel *)model{
    _model = model;
    self.textLabel.text = model.textString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
