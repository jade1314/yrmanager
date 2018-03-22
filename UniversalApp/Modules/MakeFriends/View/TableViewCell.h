//
//  TableViewCell.h
//  UniversalApp
//
//  Created by JadeM on 2017/8/1.
//  Copyright © 2017年 JadeM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong) CellModel * model;
@end
