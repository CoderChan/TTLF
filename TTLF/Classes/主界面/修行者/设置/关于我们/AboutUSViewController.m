//
//  AboutUSViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/7/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AboutUSViewController.h"
#import "NormalWebViewController.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self setupSubViews];
}

- (void)setupSubViews
{
    // logo
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2 - 35, 50, 70, 70)];
    logoImgView.image = [UIImage imageNamed:@"app_logo"];
    [self.view addSubview:logoImgView];
    
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 版本信息
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImgView.frame) + 10, self.view.width - 40, 30)];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",app_Name,app_Version];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.textColor = RGBACOLOR(138, 138, 138, 1);
    [self.view addSubview:nameLabel];
    
    // copyright
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 32, self.view.width, 30)];
    rightLabel.text = @"Copyright © 2017-2020 Yeying Technology.All Rights Reserved";
    rightLabel.font = [UIFont systemFontOfSize:10];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.textColor = nameLabel.textColor;
    [self.view addSubview:rightLabel];
    
    // 公司版权
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, rightLabel.y - 21, self.view.width, 30)];
    companyLabel.text = @"宁波夜鹰网络科技有限公司 版权所有";
    companyLabel.textColor = RGBACOLOR(98, 98, 98, 1);
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:companyLabel];
    
    // 官方网站
    UIButton *webButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [webButton setTitle:@"点击预览官方网站" forState:UIControlStateNormal];
    [webButton setTitleColor:MainColor forState:UIControlStateNormal];
    webButton.titleLabel.font = [UIFont systemFontOfSize:13];
    webButton.frame = CGRectMake(30, companyLabel.y - 21, self.view.width - 60, 30);
    [webButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NormalWebViewController *web = [[NormalWebViewController alloc]initWithUrlStr:OfficalWebURL];
        [self.navigationController pushViewController:web animated:YES];
    }];
    [self.view addSubview:webButton];
    
    
}

@end
