//
//  UUChangeMobileAndPasswordTableViewCell.m
//  UniversalApp
//
//  Created by 王玉 on 2018/5/2.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUChangeMobileAndPasswordTableViewCell.h"

@interface UUChangeMobileAndPasswordTableViewCell ()

@end

@implementation UUChangeMobileAndPasswordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.contentView addSubview:_leftImage];
        _field = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, KScreenWidth - 60 - 20, 60)];
        _field.textAlignment = NSTextAlignmentCenter;
        _field.font = [UIFont systemFontOfSize:14];
        _field.keyboardType = UIKeyboardTypeNumberPad;
        _field.textColor = COLOR_DARKGREY;
        [self.contentView addSubview:_field];
    }
    return self;
}


+(id)replaceTableViewCell:(UITableView *)tableView {
    static NSString *cellId = @"UUChangeMobileAndPasswordTableViewCell.h";
    UUChangeMobileAndPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UUChangeMobileAndPasswordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
