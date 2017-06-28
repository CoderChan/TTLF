//
//  PlayListView.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/25.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlayListView.h"
#import "AlumListTableCell.h"

@interface PlayListView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *mengButton;
}

/** 空白处 */
@property (strong,nonatomic) UIView *bottomView;
// 数据源
@property (strong,nonatomic) NSArray *array;
// 当前索引
@property (assign,nonatomic) NSInteger currentIndex;
// 列表
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation PlayListView

- (instancetype)initWithArray:(NSArray *)playList CurrentIndex:(NSInteger)currentIndex
{
    self = [super init];
    if (self) {
        self.array = playList;
        self.currentIndex = currentIndex;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BottomHeight = SCREEN_HEIGHT * 0.5;
    // 蒙蒙按钮
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.frame = CGRectMake(0, 0, self.width, SCREEN_HEIGHT - BottomHeight);
    [mengButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mengButton];
    
    
    // 底部白色View
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, BottomHeight)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0.96;
    [self addSubview:self.bottomView];
    
    
    // 取消
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitleColor:RGBACOLOR(25, 25, 25, 1) forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(0, self.bottomView.height - 50, self.width, 50);
    cancleButton.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [cancleButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.bottomView addSubview:cancleButton];
    
    
    // 出现时的动画
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height - BottomHeight;
    }];
    
    [self addTableViewAction];
}

- (void)addTableViewAction
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.width, self.bottomView.height - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = self.bottomView.backgroundColor;
    [self.bottomView addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlumListTableCell *cell = [AlumListTableCell sharedAlumCell:tableView];
    [cell.button removeFromSuperview];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    AlbumInfoModel *model = self.array[indexPath.row];
    model.index = indexPath.row + 1;
    cell.model = model;
    if (indexPath.row == self.currentIndex) {
        cell.orderLabel.textColor = MainColor;
        cell.nameLabel.textColor = MainColor;
    }else{
        cell.orderLabel.textColor = [UIColor grayColor];
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentIndex == indexPath.row) {
        [self removeFromSuperview];
    }else{
        AlbumInfoModel *model = self.array[indexPath.row];
        if (self.SelectModelBlock) {
            _SelectModelBlock(model,indexPath.row);
            [self removeFromSuperview];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


#pragma mark - 消失
- (void)removeFromSuperview
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


@end
