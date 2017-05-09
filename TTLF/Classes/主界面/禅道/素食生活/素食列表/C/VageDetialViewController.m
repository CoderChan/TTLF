//
//  VageDetialViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/7.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VageDetialViewController.h"
#import "RightMoreView.h"
#import "NormalTableViewCell.h"
#import "ImageTableViewCell.h"
#import "XLPhotoBrowser.h"



@interface VageDetialViewController ()<RightMoreViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 素食模型 */
@property (strong,nonatomic) VegeInfoModel *vegeModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@end

@implementation VageDetialViewController

- (instancetype)initWithVegeModel:(VegeInfoModel *)vegeModel
{
    self = [super init];
    if (self) {
        self.vegeModel = vegeModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.vegeModel.vege_name;
    [self setupSubViews];
}


- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    self.array = @[@[@"封面"],@[@"素食简介"],@[@"作者",@"需要的食材"],@[@"烹饪步骤"],self.vegeModel.vege_img_desc];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

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
    if (indexPath.section == 0) {
        // 封面
        ImageTableViewCell *cell = [ImageTableViewCell sharedImageCell:tableView];
        cell.image_url = self.vegeModel.vege_img;
        return cell;
    }else if (indexPath.section == 1){
        // 简介
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        } else {
            // 需要的食材
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else {
        // 步骤说明图
        ImageTableViewCell *cell = [ImageTableViewCell sharedImageCell:tableView];
        cell.image_url = self.vegeModel.vege_img_desc[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *imageArray = [NSMutableArray array];
    [imageArray addObject:self.vegeModel.vege_img];
    [imageArray addObjectsFromArray:self.vegeModel.vege_img_desc];
    
    if (indexPath.section == 0) {
        // 封面
        [XLPhotoBrowser showPhotoBrowserWithImages:imageArray currentImageIndex:0];
    }else if (indexPath.section == 1){
        // 简介
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            
        } else {
            // 需要的食材
            
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        
    }else {
        // 步骤说明图
        [XLPhotoBrowser showPhotoBrowserWithImages:imageArray currentImageIndex:indexPath.row + 1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 封面
        return 200*CKproportion;
    }else if (indexPath.section == 1){
        // 简介
        return 80;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            return 44;
        } else {
            // 需要的食材
            return 60;
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        return 120;
    }else {
        // 步骤说明图
        return 200*CKproportion;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}



#pragma mark - 其他方法
- (void)moreAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
}
- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",self.vegeModel.web_url,self.vegeModel.vege_id];
    if (clickType == WechatFriendType) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"天天礼佛：生活就是一场修行。";
        message.description = self.vegeModel.vege_desc;
        [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareUrl;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if(clickType == WechatQuanType){
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"天天礼佛：生活就是一场修行。";
        message.description = self.vegeModel.vege_desc;
        [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareUrl;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (clickType == StoreClickType){
        [[TTLFManager sharedManager].networkManager addStoreVegeWithModel:self.vegeModel Success:^{
            [MBProgressHUD showSuccess:@"已收藏"];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
    }else if (clickType == QQFriendType){
        [MBProgressHUD showSuccess:@"QQ好友"];
    }else if (clickType == QQSpaceType){
        [MBProgressHUD showSuccess:@"QQ空间"];
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        NSURL *url = [NSURL URLWithString:shareUrl];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        // 系统分享
        NSURL *url = [NSURL URLWithString:shareUrl];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[[UIImage imageNamed:@"app_logo"],self.vegeModel.vege_name,url] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (clickType == CopyUrlType){
        // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = shareUrl;
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
    }else if (clickType == RefreshType){
        // 重新加载网页
        
    }else if (clickType == StopLoadType){
        // 停止加载
    }
}

@end
