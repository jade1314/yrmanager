//
//  UUChangeMobileAndPasswordTableViewCell.h
//  UniversalApp
//
//  Created by 王玉 on 2018/5/2.
//  Copyright © 2018年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUChangeMobileAndPasswordTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UITextField *field;;
+(id)replaceTableViewCell:(UITableView *)tableView;
@end
