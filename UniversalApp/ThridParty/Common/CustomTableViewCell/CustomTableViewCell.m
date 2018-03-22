//
//  OrbYunHomeTableViewCell.m
//  PanGu
//
//  Created by 王玉 on 16/6/17.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "CustomTableViewCell.h"

#define K_ kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface CustomTableViewCell ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, retain)UIView  *cellContentView;
@property (nonatomic, retain)UIPanGestureRecognizer *panGesture;
@property (nonatomic, retain)UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign)CGFloat judgeWidth;
@property (nonatomic, assign)CGFloat rightfinalWidth;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign,readwrite)BOOL isRightBtnShow;
@property (nonatomic, assign)BOOL otherCellIsOpen;
@property (nonatomic, assign)BOOL isHiding;
@property (nonatomic, assign)BOOL isShowing;

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSMutableArray * dataArrayList;
@property (nonatomic,strong) UITableViewCell * tableCell;

@end
@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withBtns:(NSArray *)arr
          tableView:(UITableView *)tableView cellIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightBtnArr = [NSArray arrayWithArray:arr];
        self.superTableView = tableView;
        self.cellHeight = [_superTableView rectForRowAtIndexPath:indexPath].size.height;
        
        //        NSLog(@"%f",self.cellHeight);
        
        [self prepareForCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//set default select style
    }
    return self;
}

- (void)prepareForCell{
    [self setBtns];
    [self setScrollView];
    [self addObserverEvent];
    [self addGesture];
    [self addNotify];
}

#pragma mark prepareForReuser
- (void)prepareForReuse
{
    [self hideBtn];
    [super prepareForReuse];
}

#pragma mark initCell

- (void)setBtns{
    if (_rightBtnArr.count>0) {
        [self processBtns];
    }
    else{
        return;
    }
}

- (void)processBtns{
    CGFloat lastWidth = 0;
    int i = 0;
    
    for (UIButton *temBtn in _rightBtnArr)
    {
        temBtn.tag = i;
        CGRect temRect = temBtn.frame;
        temRect.origin.x = kScreenWidth - temRect.size.width - lastWidth;
        temBtn.frame = temRect;
        lastWidth = lastWidth + temBtn.frame.size.width;
        
        if (!_judgeWidth) {
            _judgeWidth = lastWidth;
        }
        
        if (_cellHeight != temBtn.frame.size.height) {
            CGRect frame = temBtn.frame;
            frame.size.height = _cellHeight;
            temBtn.frame = frame;
        }
        [temBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:temBtn];
        i++;
    }
    _rightfinalWidth = lastWidth;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setScrollView{
    _SCContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, _cellHeight)];
    _SCContentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_SCContentView];
    self.contentView.clipsToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideBtn];
}

#pragma mark events,gesture and observe

- (void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotify:)
                                                 name:@"SC_CELL_SHOULDCLOSE"
                                               object:nil];
}

- (void)handleNotify:(NSNotification *)notify{
    if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"closeCell"]) {
        [self hideBtn];
        _otherCellIsOpen = NO;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsOpen"]){
        _otherCellIsOpen = YES;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsClose"])
    {
        _otherCellIsOpen = NO;
    }
}

- (void)addObserverEvent{
    [_superTableView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldpoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newpoint = [[change objectForKey:@"new"] CGPointValue];
        if (oldpoint.y!=newpoint.y) {
            //            NSLog(@"---sueperTabelViewMoves---");
            if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
                [self hideBtn];
            }
        }
    }
}

- (void)addGesture{
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    _panGesture.delegate = self;
    [self.SCContentView addGestureRecognizer:_panGesture];
    
    //    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTaped:)];
    //    _tapGesture.delegate = self;
    //    [self.SCContentView addGestureRecognizer:_tapGesture];
}

- (void)cellTaped:(UITapGestureRecognizer *)recognizer{
    if (_otherCellIsOpen) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
    }
    else{
        NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
        [self.superTableView.delegate tableView:self.superTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    if (_isShowing||_isHiding) {
        return;
    }
    CGPoint translation = [_panGesture translationInView:self];
//    CGPoint location = [_panGesture locationInView:self];
    //    NSLog(@"translation----(%f)----loaction(%f)",translation.x,location.y);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if (fabs(translation.x)<fabs(translation.y)) {
                _superTableView.scrollEnabled = YES;
                return;
            }else{
                _superTableView.scrollEnabled = NO;
            }
            if (_otherCellIsOpen) {
                return;
            }
            //contentoffse changed
            if (translation.x<0) {
                if (self.SCContentView.frame.origin.x==_rightfinalWidth) {
                    translation.x = self.SCContentView.frame.origin.x;
                }
                [self moveSCContentView:translation.x];
            }
            else if (translation.x>0){
                //SCContentView is moving towards right
                [self hideBtn];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _superTableView.scrollEnabled = YES;
            if (_otherCellIsOpen&&!(_SCContentView.frame.origin.x == -_judgeWidth)) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
                return;
            }
            //end pan
            [self SCContentViewStop];
            break;
            
        case UIGestureRecognizerStateCancelled:
            _superTableView.scrollEnabled = YES;
            //cancell
            [self SCContentViewStop];
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)moveSCContentView:(CGFloat)offset{
    CGRect temRect = _SCContentView.frame;
    temRect.origin.x = (temRect.origin.x + offset);//adjust touch offset with your finger movement
    if (temRect.origin.x+(kScreenWidth)/2.0<0) {
        temRect.origin.x = -kScreenWidth/2.0;
    }
    if (temRect.origin.x>kScreenWidth/2.0) {
        temRect.origin.x = kScreenWidth/2.0;
    }
    _SCContentView.frame = temRect;
}

- (void)SCContentViewStop{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        //btn is shown
        if (_SCContentView.frame.origin.x + _judgeWidth<0) {
            [self showBtn];
        }
        else
        {
            [self hideBtn];
        }
    }
    else{
        if (_SCContentView.frame.origin.x+_judgeWidth>0) {
            [self hideBtn];
        }
        else{
            [self showBtn];
        }
    }
}

#pragma mark showBtn hideBtn

- (void)showBtn{
    if (!(_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isShowing) {
            [self cellWillShow];
            _isShowing = YES;
        }
    }
    _superTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        //        _SCContentView.transform = CGAffineTransformMakeTranslation(_rightfinalWidth, 0);
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = -_rightfinalWidth;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (!_isRightBtnShow) {
            [self cellDidShow];
            _isShowing = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsOpen"}];
        _superTableView.scrollEnabled = YES;
    }];
}

- (void)hideBtn{
    if ((_SCContentView.frame.origin.x == -_judgeWidth)) {
        if (_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _SCContentView.frame;
        temRect.origin.x = 0;
        _SCContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (_isRightBtnShow) {
            [self cellDidHide];
            _isHiding = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SC_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsClose"}];
        _superTableView.userInteractionEnabled = YES;
    }];
}

#pragma delegate

- (void)cellWillHide{
    if (_delegate && [_delegate respondsToSelector:@selector(cellOptionBtnWillHide)]) {
        [_delegate cellOptionBtnWillHide];
    }
}

- (void)cellWillShow{
    if (_delegate && [_delegate respondsToSelector:@selector(cellOptionBtnWillShow)]) {
        [_delegate cellOptionBtnWillShow];
    }
}

- (void)cellDidShow{
    if (_delegate && [_delegate respondsToSelector:@selector(cellOptionBtnDidShow)]) {
        [_delegate cellOptionBtnDidShow];
    }
}

- (void)cellDidHide{
    if (_delegate && [_delegate respondsToSelector:@selector(cellOptionBtnDidHide)]) {
        [_delegate cellOptionBtnDidHide];
    }
}

- (void)cellBtnClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    if (_delegate && [_delegate respondsToSelector:@selector(SCSwipeTableViewCelldidSelectBtnWithTag:andIndexPath:)]) {
        [_delegate SCSwipeTableViewCelldidSelectBtnWithTag:sender.tag andIndexPath:indexPath];
    }
    [self hideBtn];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dealloc{
    [_superTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SC_CELL_SHOULDCLOSE" object:nil];
}


#pragma -mark- tableViewCell自定义排序
-(NSMutableArray *)dataArrayList{
    if (!_dataArrayList) {
        _dataArrayList = [[NSMutableArray alloc]init];
    }
    return _dataArrayList;
}
- (void)createLongPressWithTable:(UITableView *)table tableCell:(UITableViewCell *)tableCell dataSource:(NSArray *)dataSouce isEdit:(BOOL)isEdit{
    self.table = table;
    self.tableCell = tableCell;
    [self.dataArrayList addObjectsFromArray:dataSouce];
    UILongPressGestureRecognizer *LPress;
    if (isEdit == YES) {
        LPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [tableCell addGestureRecognizer:LPress];
    }else{
        [tableCell removeGestureRecognizer:[tableCell.gestureRecognizers firstObject]];
    }
}


- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static UIView       *snapshotName = nil;
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                snapshotName.alpha = 0.0;
                [self.table addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // gesture location的偏移
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... 更新数据????
                [_dataArrayList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... 移动行
                [self.table moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                //                NSArray* array = [[DatabaseADUS getInstance] readFromTable:@"securities_information"];
                //                [[DatabaseADUS getInstance].initdatabase closeDatabase];
                //                NSMutableArray *relArr = [NSMutableArray arrayWithArray:array];
                //                [relArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //                NSDictionary *dict = [[relArr objectAtIndex:indexPath.row] toDictionary];
                //                NSString *deleteCode = dict[@"msg_code"];
                //                [[DatabaseADUS getInstance]deleteModel:dict primarykeyName:deleteCode tableName:@"securities_information"];
                //                [[DatabaseADUS getInstance].initdatabase closeDatabase];
                //                [DatabaseADUS getInstance]insert
                //                [[DatabaseADUS getInstance]insertModelForArray:relArr tableName:@"securities_information"];
                //                [[DatabaseADUS getInstance].initdatabase closeDatabase];
                //                [self.stockNameDataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                //                [self.stockNameTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.table cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}



@end
