//
//  WoViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WoViewController.h"
#import "AccountTool.h"
#import <Masonry.h>
#import "MineTableHeadView.h"
#import "MineTableViewCell.h"
#import "RootNavgationController.h"
#import "SetViewController.h"
#import "NormalTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "ShareView.h"
#import "UserInfoViewController.h"
#import "StoreListViewController.h"
#import "VisitUserViewController.h"


@interface WoViewController ()<UITableViewDelegate,UITableViewDataSource,ShareViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UserInfoModel *userModel;

@property (strong,nonatomic) MineTableHeadView *headView;

@end

@implementation WoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修行者";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    
    UIView *backTopView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT+50, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backTopView.backgroundColor = NavColor;
    [self.tableView insertSubview:backTopView atIndex:0];
    
    self.headView = [[MineTableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*CKproportion)];
    self.headView.userModel = self.userModel;
    __weak __block WoViewController *copySelf = self;
    self.headView.ClickBlock = ^(){
        UserInfoViewController *userInfo = [UserInfoViewController new];
        [copySelf.navigationController pushViewController:userInfo animated:YES];
    };
    self.tableView.tableHeaderView = self.headView;
    
    self.array = @[@[@"功德值"],@[@"收藏",@"历史",@"消息",@"分享"],@[@"设置"]];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *iconArray = @[@[@"wo_gongde"],@[@"wo_store",@"wo_history",@"wo_message",@"wo_share"],@[@"wo_set"]];;
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        VisitUserViewController *punna = [[VisitUserViewController alloc]initWithUserID:[AccountTool account].userID];
        [self.navigationController pushViewController:punna animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 收藏
            StoreListViewController *store = [StoreListViewController new];
            [self.navigationController pushViewController:store animated:YES];
        }else if (indexPath.row == 1){
            // 历史
            
        }else if (indexPath.row == 2){
            // 消息
            
        }else {
            // 分享
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            ShareView *sharedView = [[ShareView alloc]initWithFrame:keyWindow.bounds];
            sharedView.delegate = self;
            [keyWindow addSubview:sharedView];
        }
    }else{
        SetViewController *set = [SetViewController new];
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (void)shareViewClickWithType:(ShareViewClickType)type
{
    NSString *url = OfficalWebURL;
    NSString *title = @"推荐下载：佛缘生活";
    NSString *descStr = @"集佛界头条、海量佛典梵音、素食生活馆、在线礼佛、佛教名山探索的APP。";
    UIImage *image = [UIImage imageNamed:@"app_logo"];
    
    if (type == WechatFriendType) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = url;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if (type == WechatQuanType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = url;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (type == QQFriendType){
        
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:descStr previewImageData:UIImagePNGRepresentation(image)];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
        
    }else if (type == QQSpaceType){
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:descStr previewImageData:UIImagePNGRepresentation(image)];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
    }else if (type == SinaShareType){
        [MBProgressHUD showSuccess:@"新浪微博"];
    }else if (type == SysterShareType){
        
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[image,title,[NSURL URLWithString:url]] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (type == WechatStoreType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = descStr;
        [message setThumbImage:image];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = url;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 2;
        [WXApi sendReq:req];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
    return _tableView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    self.headView.userModel = self.userModel;
    [self.tableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


@end
