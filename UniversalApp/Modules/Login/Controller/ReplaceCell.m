//
//  ReplaceCell.m
//  PanGu
//
//  Created by Fll on 16/8/15.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "ReplaceCell.h"

@implementation ReplaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(ListType)type
{
    self.type = type;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (type == CATEGOTY) {
            [self customCategoryCell];
        } else if (type == FUND_CODE) {
            [self customCell];
        }
    }
    return self;
}

- (void)customCategoryCell {
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, 100, 45)];
    _leftLabel.font = [UIFont systemFontOfSize:15];
    _leftLabel.textColor = COLOR_DARKGREY;
    [self.contentView addSubview:_leftLabel];
    _singleView = [[UIView alloc]initWithFrame:CGRectMake(10, 45 - KSINGLELINE_WIDTH, kScreenWidth-54-20 - 10, KSINGLELINE_WIDTH)];
    _singleView.backgroundColor = COLOR_LINE;
    [self.contentView addSubview:_singleView];
}

-(void)setType:(ListType)type {
    _type = type;
}

- (void)customCell {
    _leftLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, (50-16)/2, 100, 15)];
    _leftLabel.font=[UIFont systemFontOfSize:15];
    _leftLabel.textColor=COLOR_DARKGREY;
    _leftLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLabel];
    
    _rightButton=[[UIButton alloc] initWithFrame:CGRectMake(self.width - 10 - 14 - 20, (50-16)/2, 14, 16)];
    [_rightButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:_rightButton];
}

+(id)replaceTableViewCell:(UITableView *)tableView type:(ListType)type {
    static NSString *cellId = @"replaceCellId";
    ReplaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ReplaceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId type:type];
        cell.backgroundColor = COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
