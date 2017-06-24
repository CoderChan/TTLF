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
#import <SVWebViewController.h>
#import "PlayingRightBarView.h"
#import "MusicListViewController.h"
#import "RootNavgationController.h"


@interface ZanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UITableView *tableView;

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
    
    PlayingRightBarView *play = [[PlayingRightBarView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    play.ClickBlock = ^{
//        MusicPlayingController *play = [[MusicPlayingController alloc]initWithModel:nil];
//        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:play];
//        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:nav animated:YES completion:^{
//            
//        }];
    };
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:play];
    self.navigationItem.rightBarButtonItem = rightItem;
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
            SVWebViewController *about = [[SVWebViewController alloc]initWithAddress:YiJijinWebURL];
            about.title = @"壹基金";
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
}


@end
