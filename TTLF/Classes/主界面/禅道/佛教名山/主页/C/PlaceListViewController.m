//
//  PlaceListViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PlaceListViewController.h"
#import "PlaceTableViewCell.h"
#import <MJRefresh.h>
#import "ProvinceViewController.h"
#import "RootNavgationController.h"
#import "PlaceDetialController.h"
#import "PlaceDetialModel.h"


@interface PlaceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation PlaceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛教名山";
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"place_select_province"] style:UIBarButtonItemStylePlain target:self action:@selector(ChangeProvinceAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
}
- (void)ChangeProvinceAction
{
    ProvinceViewController *province = [ProvinceViewController new];
    RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:province];
    province.SelectProvinceBlock = ^(NSString *province) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:province style:UIBarButtonItemStylePlain target:self action:@selector(ChangeProvinceAction)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]} forState:UIControlStateNormal];
    };
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlaceTableViewCell *cell = [PlaceTableViewCell sharedDisCoverTableCell:tableView];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceDetialModel *model = [[PlaceDetialModel alloc]init];
    model.place_id = @"5";
    model.place_name = @"杭州灵隐寺";
    model.place_img = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494164277360&di=041789287b9496fac576b9589bc6213a&imgtype=0&src=http%3A%2F%2Fpic.92to.com%2F360%2F201604%2F11%2F2556131_201208031421560125.jpg";
    model.place_travel = @"中国佛教禅宗十大古刹之一。 灵隐寺取“仙灵所隐”之意，光听名字便知其隐于山林，环境清幽。不过灵隐寺内香火鼎盛、信徒纷至，特别是大年初一凌晨抢头香，甚为壮观！据说，灵隐寺非常灵验，而飞来峰更是因为济公而名扬天下。 游人自“咫尺西天”照壁往西进入灵隐，先至理公塔前小驻。理公塔为慧理和尚骨灰埋葬之处，此塔高8米余，八角七层，是一座石塔。往右过春淙亭，一道红墙暂将灵隐寺遮住，左边便是飞来峰与冷泉，在泉边漫步，景色幽深，引人入胜。";
    model.open_time = @"07:00~18:15；停止售票时间：17:30；停止检票时间：17:45；佛诞节日、朔望、国定节假日，早上提前30分钟开门";
    model.mobie = @"0571-87968665";
    model.address = @"浙江省杭州市西湖区灵隐路法云弄1号";
    model.ticket = @"飞来峰：45.00元 灵隐寺：30.00元 Tips： 1. 进入灵隐寺必须先购买飞来峰景区门票。 2. 早上05:30以前进入飞来峰景区免票。";
    
    PlaceDetialController *placeDetial = [[PlaceDetialController alloc]initWithPlaceModel:model];
    [self.navigationController pushViewController:placeDetial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}


@end
