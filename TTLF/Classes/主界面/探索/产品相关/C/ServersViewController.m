//
//  ServersViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ServersViewController.h"
#import "NormalTableViewCell.h"
#import "AppDelegate.h"

@interface ServersViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *iconArray;

@property (copy,nonatomic) NSArray *qqArray;

@property (copy,nonatomic) NSArray *nameArray;

@end

@implementation ServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服咨询";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.iconArray = @[@"http://app.yangruyi.com/Public/home/images/huaming/caomei.png",@"http://app.yangruyi.com/Public/home/images/huaming/chaye.png",@"http://app.yangruyi.com/Public/home/images/huaming/datouluobo.png",@"http://app.yangruyi.com/Public/home/images/huaming/hongjiao.png",@"http://app.yangruyi.com/Public/home/images/huaming/yingtao.png",@"http://app.yangruyi.com/Public/home/images/huaming/qingnangua.png"];
    self.nameArray = @[@"草莓",@"茶叶",@"樱桃萝卜",@"红辣椒",@"樱桃",@"小南瓜"];
    self.qqArray = @[@"2155647772",@"3494204296",@"2040627176",@"2153702197",@"2167578676",@"3311015046"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 55;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    footView.backgroundColor = [UIColor clearColor];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, footView.width - 40, 100)];
    tipsLabel.text = @"温馨提示：点击某个客服，将会跳转到手机QQ，发起客服聊天咨询。请确保您已安装手机QQ，腾讯的手机QQ简化版TIM暂不支持发起聊天。若您未安装手机QQ将会自动复制QQ号到剪切板。";
    tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:tipsLabel];
    
    self.tableView.tableFooterView = footView;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.titleLabel.text = self.nameArray[indexPath.section];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:self.iconArray[indexPath.section]] placeholderImage:[UIImage imageNamed:@"user_place"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *qq = self.qqArray[indexPath.section];
    BOOL isInstallQQ = [TencentOAuth iphoneQQInstalled];
    if (!isInstallQQ) {
        [self showTwoAlertWithMessage:@"当前设备未安装手机QQ，已复制QQ号，请根据该QQ号联系客服。" ConfirmClick:^{
            [[UIPasteboard generalPasteboard] setString:qq];
            
        }];
        return;
    }
    NSString *openQQ = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:openQQ];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self sendAlertAction:error.localizedDescription];
}

@end
