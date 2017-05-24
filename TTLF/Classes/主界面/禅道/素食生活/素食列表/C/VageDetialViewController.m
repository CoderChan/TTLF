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
#import "AccountTool.h"
#import "NoDequeTableViewCell.h"
#import "VisitUserViewController.h"
#import "PYPhotosView.h"

#define TitleFont [UIFont systemFontOfSize:17]

@interface VageDetialViewController ()<RightMoreViewDelegate,UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate>

/** 素食模型 */
@property (strong,nonatomic) VegeInfoModel *vegeModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

/** 封面 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 素食简介 */
@property (strong,nonatomic) UILabel *vegeDescLabel;
/** 作者头像 */
@property (strong,nonatomic) UIImageView *createrHeadImgView;
/** 作者昵称 */
@property (strong,nonatomic) UILabel *createrNameLabel;
/** 需要的食材 */
@property (strong,nonatomic) UILabel *vegeFoodLabel;
/** 烹饪步骤 */
@property (strong,nonatomic) UILabel *vegeStepsLabel;
/** 素食配图 */
@property (strong,nonatomic) PYPhotosView *photosView;


/** 素食描述的label */
@property (strong,nonatomic) UILabel *descLabel;
/** 素食食材的label */
@property (strong,nonatomic) UILabel *foodLabel;
/** 烹饪步骤的label */
@property (strong,nonatomic) UILabel *stepsLabel;
/** 素食配图的label */
@property (strong,nonatomic) UILabel *imagesLabel;


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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = @[@[@"封面"],@[@"素食简介"],@[@"作者",@"需要的食材"],@[@"烹饪步骤"],@[@"素食配图"]];
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
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (indexPath.section == 0) {
        // 封面
        NoDequeTableViewCell *cell = [NoDequeTableViewCell sharedCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.contentView addSubview:self.coverImgView];
        
        return cell;
    }else if (indexPath.section == 1){
        // 简介
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        
        [cell.contentView addSubview:self.descLabel];
        [cell.contentView addSubview:self.vegeDescLabel];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            [cell.contentView addSubview:self.createrHeadImgView];
            [cell.contentView addSubview:self.createrNameLabel];
            return cell;
        } else {
            // 需要的食材
            NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.titleLabel removeFromSuperview];
            [cell.iconView removeFromSuperview];
            
            [cell.contentView addSubview:self.foodLabel];
            [cell.contentView addSubview:self.vegeFoodLabel];
            return cell;
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        [cell.contentView addSubview:self.stepsLabel];
        [cell.contentView addSubview:self.vegeStepsLabel];
        return cell;
    }else {
        // 步骤说明图
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        [cell.contentView addSubview:self.imagesLabel];
        [cell.contentView addSubview:self.photosView];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 封面
        XLPhotoBrowser *brower = [XLPhotoBrowser showPhotoBrowserWithImages:@[self.vegeModel.vege_img] currentImageIndex:0];
        brower.browserStyle = XLPhotoBrowserStyleSimple;
        brower.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
        [brower setActionSheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"发送给朋友",@"保存到相册", nil];
        
    }else if (indexPath.section == 1){
        // 简介
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            VisitUserViewController *user = [[VisitUserViewController alloc]initWithUserID:self.vegeModel.creater_id];
            [self.navigationController pushViewController:user animated:YES];
            
        } else {
            // 需要的食材
            
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        
    }else {
        // 步骤说明图

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 封面
        return 220*CKproportion;
    }else if (indexPath.section == 1){
        // 简介
        CGFloat height = [self.vegeModel.vege_desc boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        return height + 35;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 作者
            return 50;
        } else {
            // 需要的食材
            CGFloat footHeight = [self.vegeModel.vege_food boundingRectWithSize:CGSizeMake(self.view.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
            return footHeight + 35;
        }
    }else if (indexPath.section == 3){
        // 烹饪步骤说明
        CGFloat stepHeight = [self.vegeModel.vege_steps boundingRectWithSize:CGSizeMake(self.view.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        
        return stepHeight + 30 + 20;
    }else {
        // 步骤说明图
        return self.view.width + 30;
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
    NSString *shareUrl = [NSString stringWithFormat:@"%@&userID=%@",self.vegeModel.web_url,[AccountTool account].userID.base64EncodedString];
    NSLog(@"分享页 == %@",shareUrl);
    if (clickType == WechatFriendType) {
        NSData *thumbData = UIImageJPEGRepresentation(self.coverImgView.image, 0.1);
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"发现一道精选素食，送给素食生活的你。";
        message.description = self.vegeModel.vege_desc;
        [message setThumbData:thumbData];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareUrl;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if(clickType == WechatQuanType){
        NSData *thumbData = UIImageJPEGRepresentation(self.coverImgView.image, 0.1);
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"发现一道精选素食，送给素食生活的你。";
        message.description = self.vegeModel.vege_desc;
        [message setThumbData:thumbData];
        
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
            [MBProgressHUD showError:errorMsg];
        }];
    }else if (clickType == QQFriendType){
        
        NSString *title = self.vegeModel.vege_name;
        NSString *description = self.vegeModel.vege_desc;
        NSString *previewImageUrl = self.vegeModel.vege_img;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
    }else if (clickType == QQSpaceType){
        NSString *title = self.vegeModel.vege_name;
        NSString *description = self.vegeModel.vege_desc;
        NSString *previewImageUrl = self.vegeModel.vege_img;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        NSURL *url = [NSURL URLWithString:shareUrl];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        // 系统分享
        NSURL *url = [NSURL URLWithString:shareUrl];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[self.coverImgView.image,self.vegeModel.vege_name,url] applicationActivities:nil];
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
#pragma mark - XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    switch (actionSheetindex) {
        case 0:
        {
            // 发送给朋友
            UIImage *image = browser.sourceImageView.image;
            if (!image) {
                return;
            }
            
            UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[image] applicationActivities:nil];
            [self presentViewController:activity animated:YES completion:nil];
            break;
        }
        case 1:
        {
            // 保存到相册
            [browser saveCurrentShowImage];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 懒加载
// 封面
- (UIImageView *)coverImgView
{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220*CKproportion - 1)];
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:self.vegeModel.vege_img] placeholderImage:[UIImage imageWithColor:RGBACOLOR(63, 72, 123, 1)]];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
        _coverImgView.layer.masksToBounds = YES;
        _coverImgView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        
    }
    return _coverImgView;
}
// 素食描述内容
- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
        _descLabel.text = @"素食背后的故事：";
        _descLabel.font = [UIFont boldSystemFontOfSize:20];
        _descLabel.textColor = RGBACOLOR(10, 160, 79, 1);
    }
    return _descLabel;
}
- (UILabel *)vegeDescLabel
{
    if (!_vegeDescLabel) {
        
        CGFloat height = [self.vegeModel.vege_desc boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        _vegeDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, self.view.width - 30, height)];
        _vegeDescLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _vegeDescLabel.text = self.vegeModel.vege_desc;
        _vegeDescLabel.font = TitleFont;
        _vegeDescLabel.numberOfLines = 0;
    }
    return _vegeDescLabel;
}
// 创建者头像
- (UIImageView *)createrHeadImgView
{
    if (!_createrHeadImgView) {
        _createrHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 15 - 36, 7, 36, 36)];
        [_createrHeadImgView sd_setImageWithURL:[NSURL URLWithString:self.vegeModel.creater_head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _createrHeadImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_createrHeadImgView setContentScaleFactor:[UIScreen mainScreen].scale];
        _createrHeadImgView.layer.masksToBounds = YES;
        _createrHeadImgView.layer.cornerRadius = 18;
        _createrHeadImgView.autoresizingMask =  UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
    }
    return _createrHeadImgView;
}
// 创建者昵称
- (UILabel *)createrNameLabel
{
    if (!_createrNameLabel) {
        _createrNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, self.view.width - 36 - 15 - 10, 36)];
        _createrNameLabel.text = self.vegeModel.creater_name;
        _createrNameLabel.textColor = RGBACOLOR(65, 65, 65, 1);
        _createrNameLabel.textAlignment = NSTextAlignmentRight;
        _createrNameLabel.font = TitleFont;
    }
    return _createrNameLabel;
}
// 需要的食材
- (UILabel *)foodLabel
{
    if (!_foodLabel) {
        _foodLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
        _foodLabel.text = @"食材准备：";
        _foodLabel.font = [UIFont boldSystemFontOfSize:20];
        _foodLabel.textColor = RGBACOLOR(10, 160, 79, 1);
    }
    return _foodLabel;
}
- (UILabel *)vegeFoodLabel
{
    if (!_vegeFoodLabel) {
        
        CGFloat footHeight = [self.vegeModel.vege_food boundingRectWithSize:CGSizeMake(self.view.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        _vegeFoodLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, self.view.width - 20, footHeight)];
        _vegeFoodLabel.text = self.vegeModel.vege_food;
        _vegeFoodLabel.font = TitleFont;
        _vegeFoodLabel.numberOfLines = 0;
        _vegeFoodLabel.textColor = RGBACOLOR(65, 65, 65, 1);
    }
    return _vegeFoodLabel;
}
// 烹饪步骤
- (UILabel *)stepsLabel
{
    if (!_stepsLabel) {
        _stepsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
        _stepsLabel.font = [UIFont boldSystemFontOfSize:20];
        _stepsLabel.text = @"烹饪步骤：";
        _stepsLabel.textColor = RGBACOLOR(10, 160, 79, 1);
    }
    return _stepsLabel;
}
- (UILabel *)vegeStepsLabel
{
    if (!_vegeStepsLabel) {
        CGFloat stepHeight = [self.vegeModel.vege_steps boundingRectWithSize:CGSizeMake(self.view.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        _vegeStepsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, self.view.width - 30, stepHeight)];
        _vegeStepsLabel.text = self.vegeModel.vege_steps;
        _vegeStepsLabel.font = TitleFont;
        _vegeStepsLabel.numberOfLines = 0;
        _vegeStepsLabel.textColor = RGBACOLOR(65, 65, 65, 1);
    }
    return _vegeStepsLabel;
}
- (UILabel *)imagesLabel
{
    if (!_imagesLabel) {
        _imagesLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
        _imagesLabel.font = [UIFont boldSystemFontOfSize:20];
        _imagesLabel.text = @"素食配图：";
        _imagesLabel.textColor = RGBACOLOR(10, 160, 79, 1);
    }
    return _imagesLabel;
}
- (PYPhotosView *)photosView
{
    if (!_photosView) {
        
        _photosView = [PYPhotosView photosViewWithThumbnailUrls:self.vegeModel.vege_img_desc originalUrls:self.vegeModel.vege_img_desc photosMaxCol:3];
        _photosView.photoMargin = 5;
        _photosView.photoWidth = (self.view.width - 4 * _photosView.photoMargin)/3;
        _photosView.photoHeight = _photosView.photoWidth;
        _photosView.showDuration = 0.25;
        _photosView.hiddenDuration = 0.25;
        _photosView.x = _photosView.photoMargin;
        _photosView.y = _photosView.photoMargin + 30;
    }
    return _photosView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
