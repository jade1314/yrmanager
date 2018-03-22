//
//  ReplaceCell.h
//  PanGu
//
//  Created by Fll on 16/8/15.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    CATEGOTY,//用户类别
    FUND_CODE//账号
}ListType;
@interface ReplaceCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//账号

@property (nonatomic, strong) UIButton *rightButton;//删除

@property (nonatomic, strong) UIView *singleView;

@property (nonatomic, assign) ListType type;

+(id)replaceTableViewCell:(UITableView *)tableView type:(ListType)type;

@end
