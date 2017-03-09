//
//  StageInfoViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "StageInfoViewController.h"
#import "SharkNameViewController.h"
#import <Masonry.h>

@interface StageInfoViewController ()

/** 中心图片 */
@property (strong,nonatomic) UIImageView *imageV;
/** 花名 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 用户模型 */
@property (strong,nonatomic) UserInfoModel *userModel;

@end

@implementation StageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的花名";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = NavColor;
    
    // 花名图片
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.stageIcon] placeholderImage:[UIImage imageNamed:@"yaoyiyao"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-35);
        make.width.and.height.equalTo(@120);
    }];
    
    // 花名名称
    self.nameLabel.text = self.userModel.stageName;
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = MainColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.layer.shadowOffset = CGSizeMake(3, 3);
    button.layer.shadowColor = [UIColor whiteColor].CGColor;
    button.layer.shadowOpacity = 0.8;
    [button setTitle:@"摇一摇花名" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        SharkNameViewController *shark = [SharkNameViewController new];
        [self.navigationController pushViewController:shark animated:YES];
    }];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@42);
    }];
    
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
    }
    return _imageV;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.imageV.mas_bottom).offset(3);
            make.height.equalTo(@21);
        }];
    }
    return _nameLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.stageIcon] placeholderImage:[UIImage imageNamed:@"yaoyiyao"]];
    self.nameLabel.text = self.userModel.stageName;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


@end
