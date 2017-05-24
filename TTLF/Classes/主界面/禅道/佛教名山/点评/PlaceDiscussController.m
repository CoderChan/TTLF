//
//  PlaceDiscussController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PlaceDiscussController.h"
#import "PlaceDiscussTableCell.h"
#import "RootNavgationController.h"
#import "SendDiscussController.h"
#import "PlaceDiscussModel.h"
#import <MJRefresh/MJRefresh.h>
#import "PYPhotoBrowserConst.h"
#import <LCActionSheet.h>
#import "VisitUserViewController.h"


@interface PlaceDiscussController ()<UITableViewDelegate,UITableViewDataSource>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 景区模型 */
@property (strong,nonatomic) PlaceDetialModel *placeModel;

@end

@implementation PlaceDiscussController

- (instancetype)initWithModel:(PlaceDetialModel *)placeModel
{
    self = [super init];
    if (self) {
        self.placeModel = placeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看见闻";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    [[TTLFManager sharedManager].networkManager placeDiscussWithModel:self.placeModel Success:^(NSArray *array) {
        
        self.tableView.hidden = NO;
        [self hideMessageAction];
        [self.array addObjectsFromArray:array];
        [self.tableView reloadData];
        
    } Fail:^(NSString *errorMsg) {
        self.tableView.hidden = YES;
        [self showEmptyViewWithMessage:errorMsg];
    }];
    
    // 底部的评论视图
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 60)];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        SendDiscussController *sendDis = [[SendDiscussController alloc]initWithModel:self.placeModel];
        sendDis.AddCommentBlock = ^(PlaceDiscussModel *discussModel) {
            [self.array insertObject:discussModel atIndex:0];
            [self hideMessageAction];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        };
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:sendDis];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    [footView addGestureRecognizer:tap];
    // 线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, 0, footView.width, 2);
    [footView addSubview:xian];
    // 图标
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"place_edit"]];
    iconView.frame = CGRectMake(footView.width/2 - 90, 15, 30, 30);
    [footView addSubview:iconView];
    // 写点评
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 15, 200, 30)];
    label.text = @"分享见闻，编写点评";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = MainColor;
    [footView addSubview:label];
    
    [self.view addSubview:footView];
    
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
    PlaceDiscussTableCell *cell = [PlaceDiscussTableCell sharedDiscussCell:tableView];
    cell.ClickUserBlock = ^(NSString *userID) {
        VisitUserViewController *user = [[VisitUserViewController alloc]initWithUserID:userID];
        [self.navigationController pushViewController:user animated:YES];
    };
    PlaceDiscussModel *model = self.array[indexPath.row];
    cell.discussModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDiscussModel *model = self.array[indexPath.row];
    Account *account = [AccountTool account];
    if ([model.creater_id isEqualToString:account.userID]) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 删除我发布的评论
                    [[TTLFManager sharedManager].networkManager deletePlaceCommentWithModel:model Success:^{
                        [self.array removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                    } Fail:^(NSString *errorMsg) {
                        [MBProgressHUD showError:errorMsg];
                    }];
                }
            } otherButtonTitles:@"删除", nil];
            sheet.destructiveButtonIndexSet = [NSSet setWithObjects:@1, nil];
            [sheet show];
        }];
        action.backgroundColor = WarningColor;
        return @[action];
    }else{
        return NULL;
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDiscussModel *model = self.array[indexPath.row];
    Account *account = [AccountTool account];
    if ([model.creater_id isEqualToString:account.userID]) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDiscussModel *model = self.array[indexPath.row];
    CGFloat textHeight = [model.discuss_content boundingRectWithSize:CGSizeMake(self.view.width - 61 - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    if (model.scenic_img_desc.count == 0) {
        // 无图
        return 10 + 10 + 20 + textHeight + 25 + 10;
    }else if (model.scenic_img_desc.count > 0 && model.scenic_img_desc.count < 4){
        // 1-3张图
        return 10 + 10 + 20 + textHeight + (8 + 10 + PYPhotoHeight) + 25;
    }else if (model.scenic_img_desc.count >= 4 && model.scenic_img_desc.count < 7){
        // 4-6张图
        return 10 + 10 + 20 + textHeight + (8 + 15 + PYPhotoHeight * 2) + 25;
    }else{
        // 7-9张图
        return 10 + 10 + 20 + textHeight + (8 + 20 + PYPhotoHeight * 3) + 25;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
