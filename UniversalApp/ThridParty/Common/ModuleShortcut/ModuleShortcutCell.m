//
//  ModuleShortcutCell.m
//  PanGu
//
//  Created by jade on 2016/10/29.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "ModuleShortcutCell.h"

@implementation ModuleShortcutCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = COLOR_LINE.CGColor;
        self.contentView.layer.borderWidth = KSINGLELINE_WIDTH;
        [self customCell];
    }
    return self;
}

// section == 0, 点击减号, 删除cell, 删除数据源, animation
- (void)deleteSectionZeroCell:(UITapGestureRecognizer *)tapGes {
    
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        ModuleShortcutCell *moduleShortcutCell = (ModuleShortcutCell *)tapGes.view.superview.superview;
        
        // 删除数据源
        _deleteCellBlock(moduleShortcutCell);
        
        // 删除 cell Animation
        [self deleteAnimation];
    }
}

- (void)deleteAnimation {
    
//    [UIView animateWithDuration:1.f animations:^{
        self.size = CGSizeZero;
//    } completion:^(BOOL finished) {
        self.alpha = 0;
//    }];
}

- (void)layoutUI {
    
    _iconImageView.left = (self.contentView.width - _iconImageView.width) / 2;
    _iconImageView.top = 10;
    
    [_titleLabel sizeToFit];
    _titleLabel.left = (self.contentView.width - _titleLabel.width) / 2;
    _titleLabel.top = _iconImageView.bottom + 5;
}

- (void)setModuleShortcutModel:(ModuleShortcutModel *)moduleShortcutModel {
    
    _moduleShortcutModel = moduleShortcutModel;
    
    _iconImageView.image = ImageNamed(@"shareqq");//_moduleShortcutModel.icon_image
    _titleLabel.text = _moduleShortcutModel.title;
    
    [self layoutUI];
}

- (void)customCell {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = COLOR_DARKGREY;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.height = 14;
    _titleLabel = titleLabel;
    
    _stateImageView = ({
        UIImageView *stateImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:stateImageView];
        stateImageView.size = CGSizeMake(15, 15);
        stateImageView.top = 5;
        stateImageView.right = self.width - 5;
        stateImageView.layer.masksToBounds = YES;
        stateImageView.layer.cornerRadius = stateImageView.width / 2;
        stateImageView.backgroundColor = random_color;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSectionZeroCell:)];
        stateImageView.userInteractionEnabled = YES;
        [stateImageView addGestureRecognizer:tapGes];
        
        stateImageView;
    });
}

@end
