//
//  ZanViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ZanViewController.h"
#import "NormalTableViewCell.h"
#import "LiFoViewController.h"
#import "MyBooksViewController.h"
#import "MusicPlayingController.h"
#import "VegeViewController.h"
#import "PlaceListViewController.h"
#import "GoodnessViewController.h"
#import "NormalWebViewController.h"
#import "PlayingRightBarView.h"
#import "MusicListViewController.h"
#import "RootNavgationController.h"
#import "MusicPlayerManager.h"
#import <Masonry.h>


@interface ZanViewController ()<UITableViewDelegate,UITableViewDataSource>

// 数据源
@property (copy,nonatomic) NSArray *array;
// 表格
@property (strong,nonatomic) UITableView *tableView;
// rightBar
@property (strong,nonatomic) PlayingRightBarView *rightBar;
//
@property (strong,nonatomic) UILabel *msgLabel;

@end

@implementation ZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"禅道";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.array = @[@[@"佛典",@"梵音"],@[@"天天礼佛",@"日行一善"],@[@"素食生活",@"佛教名山"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 108) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.array count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *imageArr = @[@[@"zen_book",@"zen_music"],@[@"zen_heart",@"zan_xingshan"],@[@"zen_vangen",@"zen_smile"]];
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
    cell.iconView.image = [UIImage imageNamed:imageArr[indexPath.section][indexPath.row]];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.msgLabel];
        }
    }
    [cell.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.and.height.equalTo(@30);
    }];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 佛典
            MyBooksViewController *myBook = [MyBooksViewController new];
            [self.navigationController pushViewController:myBook animated:YES];
        }else{
            // 梵音
            MusicListViewController *music = [MusicListViewController new];
            [self.navigationController pushViewController:music animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 天天礼佛
            LiFoViewController *lifo = [LiFoViewController new];
            [TTLFManager sharedManager].lifoVC = lifo;
            [self.navigationController pushViewController:lifo animated:YES];
        }else{
            // 日行一善
            NormalWebViewController *about = [[NormalWebViewController alloc]initWithUrlStr:YiJijinWebURL];
            about.title = @"日行一善";
            [self.navigationController pushViewController:about animated:YES];
        }
        
    }else{
        if (indexPath.row == 0) {
            // 素食生活
            VegeViewController *vegeVC = [VegeViewController new];
            [self.navigationController pushViewController:vegeVC animated:YES];
        }else{
            // 佛教名山
            PlaceListViewController *place = [[PlaceListViewController alloc]init];
            [self.navigationController pushViewController:place animated:YES];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:NavColor];
    __weak ZanViewController *copySelf = self;
    
    self.rightBar.ClickBlock = ^{
        NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
        NSString *lastCateID = [UD objectForKey:LastMusicCateID];
        NSString *lastIndex = [UD objectForKey:LastMusicIndex];
        
        if (lastCateID && lastIndex) {
            // 之前选过
            [[TTLFManager sharedManager].networkManager getCacheAlbumListByCateID:lastCateID Success:^(NSArray *array) {
                MusicPlayingController *play = [[MusicPlayingController alloc]initWithArray:array CurrentIndex:[lastIndex integerValue]];
                [copySelf.navigationController pushViewController:play animated:YES];
            } Fail:^(NSString *errorMsg) {
                [copySelf showPopTipsWithMessage:errorMsg AtView:copySelf.rightBar inView:copySelf.view];
            }];
        }else{
            // 第一次进来，或者是新登录
            [copySelf showPopTipsWithMessage:@"请先进入梵音界面，选中列表播放" AtView:copySelf.rightBar inView:copySelf.view];
        }
        
    };
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 动画
    if ([[MusicPlayerManager sharedManager].fsController isPlaying]) {
        // 播放，旋转
        [copySelf.rightBar remoteAnimation];
    }else{
        // 没有播放，不旋转
        [copySelf.rightBar stopAnimation];
    }

}
- (PlayingRightBarView *)rightBar
{
    if (!_rightBar) {
        _rightBar = [[PlayingRightBarView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    return _rightBar;
}
- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - 30 - 70, 10, 70, 30)];
        _msgLabel.text = @"+1功德值";
        _msgLabel.textAlignment = NSTextAlignmentRight;
        _msgLabel.textColor = WarningColor;
        _msgLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _msgLabel;
}

@end
