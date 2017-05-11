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
#import "PunnaNumViewController.h"
#import "VisitUserViewController.h"

#define TitleFont [UIFont systemFontOfSize:17]

@interface VageDetialViewController ()<RightMoreViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 素食模型 */
@property (strong,nonatomic) VegeInfoModel *vegeModel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

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

/** 素食描述的label */
@property (strong,nonatomic) UILabel *descLabel;
/** 素食食材的label */
@property (strong,nonatomic) UILabel *foodLabel;
/** 烹饪步骤的label */
@property (strong,nonatomic) UILabel *stepsLabel;


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
    
    if (self.isPresent) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = @[@[@"封面"],@[@"素食简介"],@[@"作者",@"需要的食材"],@[@"烹饪步骤"],self.vegeModel.vege_img_desc];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        ImageTableViewCell *cell = [ImageTableViewCell sharedImageCell:tableView];
        cell.image_url = self.vegeModel.vege_img;
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
            if ([[AccountTool account].userID isEqualToString:self.vegeModel.creater_id]) {
                // 自己
                PunnaNumViewController *punna = [[PunnaNumViewController alloc]init];
                [self.navigationController pushViewController:punna animated:YES];
            }else{
                // 别人
                VisitUserViewController *user = [[VisitUserViewController alloc]initWithUserID:self.vegeModel.creater_id];
                [self.navigationController pushViewController:user animated:YES];
            }
            
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
        return 220*CKproportion;
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
        message.title = [NSString stringWithFormat:@"%@-%@",self.vegeModel.vege_name,self.vegeModel.vege_desc];
        message.description = @"天天礼佛APP：您掌上的素食生活馆";
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
        message.title = [NSString stringWithFormat:@"%@-%@",self.vegeModel.vege_name,self.vegeModel.vege_desc];
        message.description = @"天天礼佛APP：您掌上的素食生活馆";
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
            [MBProgressHUD showError:errorMsg];
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

#pragma mark - 懒加载
// 素食描述内容
- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
        _descLabel.text = @"素食背后的故事：";
        _descLabel.font = [UIFont boldSystemFontOfSize:20];
        _descLabel.textColor = MainColor;
    }
    return _descLabel;
}
- (UILabel *)vegeDescLabel
{
    if (!_vegeDescLabel) {
        
        CGFloat height = [self.vegeModel.vege_desc boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
        _vegeDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, self.view.width - 30, height)];
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
        _foodLabel.textColor = MainColor;
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
        _stepsLabel.textColor = MainColor;
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




@end
