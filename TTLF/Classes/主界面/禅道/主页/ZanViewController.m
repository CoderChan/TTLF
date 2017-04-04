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
#import "ZuoCanViewController.h"
#import "MusicPlayingController.h"


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
    
    self.array = @[@[@"佛典",@"梵音"],@[@"素食生活",@"放生活动"],@[@"天天礼佛",@"坐禅冥想"]];
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
    NSArray *imageArr = @[@[@"zen_book",@"zen_music"],@[@"zen_vangen",@"zen_smile"],@[@"zen_heart",@"zen_think"]];
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
            MyBooksViewController *myBook = [MyBooksViewController new];
            [self.navigationController pushViewController:myBook animated:YES];
        }else{
            MusicPlayingController *music = [MusicPlayingController new];
            [self.navigationController pushViewController:music animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [MBProgressHUD showStore:@"非常成功" Type:YES];
        }else{
            [MBProgressHUD showWarn:@"我在南山南"];
        }
    }else{
        if (indexPath.row == 0) {
            // 天天礼佛
            LiFoViewController *lifo = [LiFoViewController new];
            [TTLFManager sharedManager].lifoVC = lifo;
            [self.navigationController pushViewController:lifo animated:YES];
        }else{
            // 冥想
            ZuoCanViewController *zuocan = [ZuoCanViewController new];
            [self.navigationController pushViewController:zuocan animated:YES];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:NavColor];
}


@end
