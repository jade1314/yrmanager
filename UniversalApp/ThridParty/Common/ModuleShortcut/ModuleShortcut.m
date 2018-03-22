//
//  ModuleShortcut.m
//  PanGu
//
//  Created by jade on 2016/10/28.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "ModuleShortcut.h"
#import "ModuleShortcutCell.h"

#define MinimumPressDuration 0.3

@interface ModuleShortcut() <UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *allData;              // 全部的模块
@property (nonatomic, strong) NSMutableArray *selectData;           // 选中的模块
@property (nonatomic, strong) NSIndexPath    *originalIndexPath;    // 原来的 IndexPath
@property (nonatomic, strong) NSIndexPath    *moveIndexPath;        // 移动的 IndexPath
@property (nonatomic, assign) CGPoint        lastPoint;             // 最后一个点
@property (nonatomic, strong) UIView         *tempMoveCell;         // 记录临时的 Cell
@property (nonatomic, strong) NSMutableArray *headerTitle;          // 头视图标题

@end

@implementation ModuleShortcut

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self) {
        
        self = [super initWithFrame:frame collectionViewLayout:layout];
        self.height -= NAV_HEIGHT;
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"ModuleShortcut" ofType:@"plist"];
        _allData = [ModuleShortcutModel mj_objectArrayWithFilename:@"ModuleShortcut.plist"];
        [_allData enumerateObjectsUsingBlock:^(ModuleShortcutModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!_selectData) {
                _selectData = @[].mutableCopy;
            }
            if ([obj.state intValue] == 1) {
                [_selectData addObject:obj];
            }
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        //设置长按时间
        longPress.minimumPressDuration = MinimumPressDuration;
        [self addGestureRecognizer:longPress];
        
        [self registerClass:[ModuleShortcutCell class] forCellWithReuseIdentifier:@"ModuleShortcutCell"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ModuleShortcutHeader"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ModuleShortcutFooter"];
    }
    return self;
}

#pragma mark LongPress
- (void)longPressed:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self gestureBegan:longPressGesture];
    }else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        [self gestureChange:longPressGesture];
    }else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        [self gestureEndOrCancle:longPressGesture];
    }
}

// LongPressBegan
- (void)gestureBegan:(UILongPressGestureRecognizer *)longPressGesture{
    
    //获取手指所在的cell
    _originalIndexPath = [self indexPathForItemAtPoint:[longPressGesture locationOfTouch:0 inView:longPressGesture.view]];
    if (_originalIndexPath.section == 0) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
        //截图大法，得到cell的截图视图
        UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
        _tempMoveCell = tempMoveCell;
        _tempMoveCell.frame = cell.frame;
        [self addSubview:_tempMoveCell];
        //隐藏cell
        cell.hidden = YES;
        //记录当前手指位置
        _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    }
}

// LongPressChange
- (void)gestureChange:(UILongPressGestureRecognizer *)longPressGesture{
    
    if (_originalIndexPath.section == 0) {
        //计算移动距离
        CGFloat tranX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - _lastPoint.x;
        CGFloat tranY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - _lastPoint.y;
        //设置截图视图位置
        _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
        _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
        //计算截图视图和哪个cell相交
        for (UICollectionViewCell *cell in [self visibleCells]) {
            //剔除隐藏的cell
            if ([self indexPathForCell:cell] == _originalIndexPath) {
                continue;
            }
            //计算中心距
            CGFloat space = sqrtf(pow(_tempMoveCell.center.x - cell.center.x, 2) + powf(_tempMoveCell.center.y - cell.center.y, 2));
            //如果相交一半就移动
            if (space <= _tempMoveCell.bounds.size.width / 2) {
                _moveIndexPath = [self indexPathForCell:cell];
                //更新数据源（移动前必须更新数据源）
                [self updateDataSource];
                //移动
                [self moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                //通知代理
                //设置移动后的起始indexPath
                _originalIndexPath = _moveIndexPath;
                break;
            }
        }
    }
}

// LongPressEnd
- (void)gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture{
    
    if (_originalIndexPath.section == 0) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
        //结束动画过程中停止交互，防止出问题
        self.userInteractionEnabled = NO;
        //给截图视图一个动画移动到隐藏cell的新位置
        [UIView animateWithDuration:0.25 animations:^{
            _tempMoveCell.center = cell.center;
        } completion:^(BOOL finished) {
            //移除截图视图、显示隐藏cell并开启交互
            [_tempMoveCell removeFromSuperview];
            cell.hidden = NO;
            self.userInteractionEnabled = YES;
        }];        
    }
}

#pragma mark UpdateData
- (void)updateDataSource {
    
    NSMutableArray *temp = _allData.mutableCopy;
    //通过代理获取数据源，该代理方法必须实现
//    if ([self.dataSource respondsToSelector:@selector(dataSourceArrayOfCollectionView:)]) {
//        [temp addObjectsFromArray:[self.dataSource dataSourceArrayOfCollectionView:self]];
//    }
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
//    BOOL dataTypeCheck = ([self numberOfSections] != 1 || ([self numberOfSections] == 1 && [temp[0] isKindOfClass:[NSArray class]]));
    //先将数据源的数组都变为可变数据方便操作
//    if (dataTypeCheck) {
//        for (int i = 0; i < temp.count; i ++) {
//            [temp replaceObjectAtIndex:i withObject:[temp[i] mutableCopy]];
//        }
//    }
    if (_moveIndexPath.section == _originalIndexPath.section) {
        //在同一个section中移动或者只有一个section的情况（原理就是将原位置和新位置之间的cell向前或者向后平移）
//        NSMutableArray *orignalSection = dataTypeCheck ? temp[_originalIndexPath.section] : temp;
        if (_moveIndexPath.item > _originalIndexPath.item) {
            for (NSUInteger i = _originalIndexPath.item; i < _moveIndexPath.item ; i ++) {
                [temp exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else{
            for (NSUInteger i = _originalIndexPath.item; i > _moveIndexPath.item ; i --) {
                [temp exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }else{
        //在不同section之间移动的情况（原理是删除原位置所在section的cell并插入到新位置所在的section中）
        /*
        NSMutableArray *orignalSection = temp[_originalIndexPath.section];
        NSMutableArray *currentSection = temp[_moveIndexPath.section];
        [currentSection insertObject:orignalSection[_originalIndexPath.item] atIndex:_moveIndexPath.item];
        [orignalSection removeObject:orignalSection[_originalIndexPath.item]];
         */
    }
    _allData = temp;
    //将重排好的数据传递给外部,在外部设置新的数据源，该代理方法必须实现
//    if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:newDataArrayAfterMove:)]) {
//        [self.delegate dragCellCollectionView:self newDataArrayAfterMove:temp.copy];
//    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _selectData.count;
    } else {
        return _allData.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"ModuleShortcutCell";
    __weak ModuleShortcutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.moduleShortcutModel = indexPath.section == 0 ? _selectData[indexPath.row] : _allData[indexPath.row];
    
    uWeakSelf
    cell.deleteCellBlock = ^(ModuleShortcutCell *moduleShortcutCell) {
        
        if (indexPath.section == 0) {
            
            NSIndexPath *delectIndexPath = [self indexPathForCell:moduleShortcutCell];
            
            [weakSelf.selectData removeObjectAtIndex:delectIndexPath.row];
            
            [weakSelf deleteItemsAtIndexPaths:@[delectIndexPath]];
            
        } else {
        
            
            
        }
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *moduleShortcutHeaderFooter = [UICollectionReusableView new];
    if (kind == UICollectionElementKindSectionHeader) {
        
        NSString *headerIdentifier = @"ModuleShortcutHeader";
        
        moduleShortcutHeaderFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        UILabel *titleLabel = (UILabel *)[moduleShortcutHeaderFooter viewWithTag:3000 + indexPath.section];
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 30)];
            [moduleShortcutHeaderFooter addSubview:titleLabel];
            titleLabel.tag = 3000 + indexPath.section;
            titleLabel.text = self.headerTitle[indexPath.section];
            titleLabel.textColor = COLOR_DARKGREY;
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }else if (kind == UICollectionElementKindSectionFooter) {
        NSString *footerIdentifier = @"ModuleShortcutFooter";
        
        moduleShortcutHeaderFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        
        moduleShortcutHeaderFooter.backgroundColor = COLOR_BACK;
    }
    
    return moduleShortcutHeaderFooter;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = (self.width - 50 - KSINGLELINE_WIDTH) / 4;
    
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
//    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 10);
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark Lazy
- (NSMutableArray *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = @[@"我的应用", @"为你推荐"].mutableCopy;
    }
    return _headerTitle;
}

@end
