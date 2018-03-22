//
//  ModuleShortcutCell.h
//  PanGu
//
//  Created by jade on 2016/10/29.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleShortcutModel.h"

@interface ModuleShortcutCell : UICollectionViewCell

@property (nonatomic, strong) ModuleShortcutModel *moduleShortcutModel;

//@property (nonatomic, copy) void()
@property (nonatomic, copy) void(^deleteCellBlock)(ModuleShortcutCell *moduleShortcutCell);

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *stateImageView;

// 保存到 plist 文件的修改操作最后点击完成是执行

// section == 0, 点击减号, 删除cell, 删除数据源, animation
- (void)deleteSectionZeroCell;

// section == 1, 点击加号, 修改 cell.stateImageView 状态, 修改数据源, animation
//- (void)add

- (void)deleteAnimation;

@end
