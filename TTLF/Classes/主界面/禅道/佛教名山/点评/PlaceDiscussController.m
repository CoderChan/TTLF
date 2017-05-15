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


@interface PlaceDiscussController ()<UITableViewDelegate,UITableViewDataSource>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation PlaceDiscussController

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
    self.tableView.rowHeight = 380;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, 60)];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        SendDiscussController *sendDis = [SendDiscussController new];
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
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDiscussTableCell *cell = [PlaceDiscussTableCell sharedDiscussCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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




@end
