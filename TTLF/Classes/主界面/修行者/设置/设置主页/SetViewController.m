//
//  SetViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SetViewController.h"
#import "NormalTableViewCell.h"
#import "TitleTableCell.h"
#import <LCActionSheet.h>
#import "NormalWebViewController.h"
#import "SharkNameViewController.h"
#import "NewFetherViewController.h"
#import "SuggestViewController.h"
#import "RootNavgationController.h"
#import "WechatLoginViewController.h"
#import "PhoneLoginViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (copy,nonatomic) NSArray *titleArray;
@property (copy,nonatomic) NSArray *iconArray;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.titleArray = @[@[@"欢迎页",@"摇一摇花名",@"关于我们"],@[@"意见反馈",@"清除缓存"],@[@"退出登录"]];
    self.iconArray = @[@[@"set_welcome",@"set_shark",@"set_about"],@[@"set_suggest",@"set_clean"],@"set_return"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 50;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.iconView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        return cell;
    }else{
        TitleTableCell *cell = [TitleTableCell sharedTitleTableCell:tableView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 欢迎页
            CATransition *animation = [CATransition animation];
            animation.duration = 0.2;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionFade;
            animation.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:animation forKey:nil];
            
            NewFetherViewController *safe = [NewFetherViewController new];
            [self presentViewController:safe animated:NO completion:^{
                
            }];
        }else if(indexPath.row == 1){
            // 摇一摇花名
            SharkNameViewController *shark = [SharkNameViewController new];
            [self.navigationController pushViewController:shark animated:YES];
        }else{
            // 关于我们
            NormalWebViewController *web = [[NormalWebViewController alloc]initWithUrlStr:OfficalWebURL];
            [self.navigationController pushViewController:web animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 意见反馈
            SuggestViewController *suggest = [SuggestViewController new];
            [self.navigationController pushViewController:suggest animated:YES];
        }else{
            // 清除缓存
            
        }
    }else {
        // 退出当前账号
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定退出，换号登录？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[TTLFManager sharedManager].networkManager returnAccountSuccess:^{
                    [self reloginSuccess];
                } Fail:^(NSString *errorMsg) {
                    [self sendAlertAction:errorMsg];
                }];
            }
        } otherButtonTitles:@"确定退出", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}


- (void)reloginSuccess
{
    if ([WXApi isWXAppInstalled]) {
        WechatLoginViewController *tabbar = [[WechatLoginViewController alloc]init];
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:tabbar];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.6;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        window.rootViewController = nav;
        [window makeKeyAndVisible];
    }else{
        PhoneLoginViewController *tabbar = [[PhoneLoginViewController alloc]init];
        RootNavgationController *nav = [[RootNavgationController alloc]initWithRootViewController:tabbar];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.6;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        window.rootViewController = nav;
        [window makeKeyAndVisible];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


@end
