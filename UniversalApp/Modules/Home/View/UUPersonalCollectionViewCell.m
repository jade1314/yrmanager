//
//  UUPersonalCollectionViewCell.m
//  UniversalApp
//
//  Created by 王玉 on 2018/4/4.
//  Copyright © 2018年 UU. All rights reserved.
//

#import "UUPersonalCollectionViewCell.h"

@implementation UUPersonalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"UUPersonalCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}
@end
