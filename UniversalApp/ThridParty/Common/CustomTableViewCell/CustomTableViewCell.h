//
//  OrbYunHomeTableViewCell.h
//  PanGu
//
//  Created by 王玉 on 16/6/17.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTableViewCellDelegate <NSObject>

/**
 *  编辑状态点击编辑按钮回调方法
 *
 *  @param tag       编辑按钮的tag标记
 *  @param indexpath 编辑cell所在的indexPath
 */
- (void)SCSwipeTableViewCelldidSelectBtnWithTag:(NSInteger)tag
                                   andIndexPath:(NSIndexPath *)indexpath;

/**
 *  cell将要显示
 */
- (void)cellOptionBtnWillShow;
/**
 *  cell将要隐藏
 */
- (void)cellOptionBtnWillHide;
/**
 *  cell已经显示
 */
- (void)cellOptionBtnDidShow;
/**
 *  cell已经隐藏
 */
- (void)cellOptionBtnDidHide;

@end
@interface CustomTableViewCell : UITableViewCell

/**
 *  delegate
 */
@property (nonatomic, weak)id<CustomTableViewCellDelegate>delegate;


/**
 *  编辑按钮数组
 */
@property (nonatomic, retain)NSArray *rightBtnArr;


/**
 *  cell背景颜色
 */
@property (nonatomic, retain)UIColor *cellBackGroundColor;


/**
 *  SCContentView
 */
@property (nonatomic, retain)UIView *SCContentView;


/**
 *  superTableView
 */
@property (nonatomic, retain)UITableView *superTableView;


/**
 *  右面编辑按钮显示状态
 */
@property (nonatomic, assign, readonly)BOOL isRightBtnShow;

/**
 *  初始化编辑按钮
 *
 *  @param style           cell的样式
 *  @param reuseIdentifier 复用标识
 *  @param arr             编辑按钮数组
 *  @param tableView       编辑的tableView
 *  @param indexPath       indexPath
 *
 *  @return cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withBtns:(NSArray<UIButton *> *)arr
          tableView:(UITableView *)tableView
      cellIndexPath:(NSIndexPath *)indexPath;


/**
 *  添加拖动动画
 *
 *  @param table     添加动画的TableView
 *  @param tableCell 添加动画的tableViewCell
 *  @param dataSouce 数据源
 *  @param isEdit    编辑状态
 */
- (void)createLongPressWithTable:(UITableView *)table
                       tableCell:(UITableViewCell *)tableCell
                      dataSource:(NSArray *)dataSouce
                          isEdit:(BOOL)isEdit;

@end
