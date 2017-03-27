//
//  PunnaNumViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PunnaNumViewController.h"
#import "DrawCircleView.h"
#import <LCActionSheet.h>
#import <Masonry.h>
#import "PunnaListViewController.h"
#import "AboutPunnaViewController.h"


@interface PunnaNumViewController ()

@property (strong,nonatomic) UILabel *punnaLabel;

@end

@implementation PunnaNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功德值";
    self.view.backgroundColor = NavColor;
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    DrawCircleView *circleView = [[DrawCircleView alloc]initWithFrame:CGRectMake(0, 100*CKproportion, self.view.width, self.view.width)];
    circleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:circleView];
    
    self.punnaLabel = [[UILabel alloc]init];
    self.punnaLabel.text = [[TTLFManager sharedManager].userManager getUserInfo].punnaNum;
    self.punnaLabel.textColor = [UIColor whiteColor];
    self.punnaLabel.font = [UIFont boldSystemFontOfSize:30];
    self.punnaLabel.textAlignment = NSTextAlignmentCenter;
    [circleView addSubview:self.punnaLabel];
    [self.punnaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleView.mas_centerX);
        make.centerY.equalTo(circleView.mas_centerY).offset(-25);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
}

- (void)moreAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            PunnaListViewController *list = [PunnaListViewController new];
            [self.navigationController pushViewController:list animated:YES];
        } else if(buttonIndex == 2){
            AboutPunnaViewController *about = [AboutPunnaViewController new];
            [self.navigationController pushViewController:about animated:YES];
        }
    } otherButtonTitles:@"增长记录",@"了解功德值", nil];
    [sheet show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


@end
