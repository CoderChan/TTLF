//
//  ServersViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/19.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ServersViewController.h"
#import "NormalTableViewCell.h"

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
    self.nameArray = @[@"草莓",@"茶叶",@"大头萝卜",@"红辣椒",@"樱桃",@"小南瓜"];
    self.qqArray = @[@"2155647772",@"3494204296",@"2040627176",@"2153702197",@"2167578676",@"3311015046"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 55;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    
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
    
    NSString *qq = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.qqArray[indexPath.section]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:qq];
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
