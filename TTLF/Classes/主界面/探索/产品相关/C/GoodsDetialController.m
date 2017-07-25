//
//  GoodsDetialController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GoodsDetialController.h"
#import "NormalTableViewCell.h"
#import "UIButton+Category.h"
#import "NormalWebViewController.h"
#import "ServersViewController.h"
#import "GoodDetialFootView.h"
#import <SDCycleScrollView.h>
#import "PYPhotoBrowser.h"
#import "GoodsInfoModel.h"
#import "RightMoreView.h"
#import "CMPopTipView.h"
#import "PayOrderViewController.h"
#import "GoodsStandardController.h"


@interface GoodsDetialController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,RightMoreViewDelegate>

// 商品模型
@property (strong,nonatomic) GoodsInfoModel *model;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 轮播图 */
@property (strong,nonatomic) SDCycleScrollView *scrollView;
/** 商品详细名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 商品售价 */
@property (strong,nonatomic) UILabel *salePriceLabel;
/** 商品原价 */
@property (strong,nonatomic) UILabel *oldPriceLabel;


@end

@implementation GoodsDetialController

- (instancetype)initWithModel:(GoodsInfoModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"饰品详情";
    
    [self setupSubViews];
}

#pragma mark - 绘制表格
- (void)setupSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
    // 添加表格
    self.array = @[@[@"封面轮播图"],@[@"商品名称.商品价格"],@[@"产品规格"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    // 左边：客服、淘宝。
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.4, 50)];
    leftView.userInteractionEnabled = YES;
    leftView.layer.shadowOpacity = 0.8;
    leftView.layer.shadowColor = [UIColor blackColor].CGColor;
    leftView.layer.shadowRadius = 5;
    leftView.layer.shadowOffset = CGSizeMake(5, 5);
    leftView.backgroundColor = RGBACOLOR(247, 247, 217, 1);
    [self.view addSubview:leftView];
    
    // 客服
    UIButton *serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serverBtn.frame = CGRectMake(0, 0, leftView.width/2, leftView.height);
    [serverBtn setTitle:@"客服" forState:UIControlStateNormal];
    [serverBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [serverBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        ServersViewController *server = [[ServersViewController alloc]init];
        [self.navigationController pushViewController:server animated:YES];
    }];
    serverBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [serverBtn setImage:[UIImage imageNamed:@"good_kefu"] forState:UIControlStateNormal];
    [serverBtn setImage:[UIImage imageNamed:@"good_kefu"] forState:UIControlStateHighlighted];
    [leftView addSubview:serverBtn];
    [serverBtn centerImageAndTitle:5];
    
    // 淘宝
    UIButton *taobaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    taobaoBtn.frame = CGRectMake(serverBtn.width, 0, leftView.width/2, leftView.height);
    [taobaoBtn setTitle:@"淘宝" forState:UIControlStateNormal];
    [taobaoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [taobaoBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        NormalWebViewController *taobao = [[NormalWebViewController alloc]initWithUrlStr:self.model.taobao_url];
        [self.navigationController pushViewController:taobao animated:YES];
        
    }];
    taobaoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [taobaoBtn setImage:[UIImage imageNamed:@"good_taobao"] forState:UIControlStateNormal];
    [taobaoBtn setImage:[UIImage imageNamed:@"good_taobao"] forState:UIControlStateHighlighted];
    [leftView addSubview:taobaoBtn];
    [taobaoBtn centerImageAndTitle:2.5];
    
    // 加入购物车
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = RGBACOLOR(63, 72, 123, 1);
    addButton.frame = CGRectMake(leftView.width, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.3, 50);
    addButton.layer.shadowOpacity = 0.8;
    addButton.layer.shadowColor = [UIColor blackColor].CGColor;
    addButton.layer.shadowRadius = 5;
    addButton.layer.shadowOffset = CGSizeMake(5, 5);
    [addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        
        [[TTLFManager sharedManager].networkManager addGoodsToOrderListWithModel:self.model Nums:@"1" Remark:nil Success:^{
            [YLNotificationCenter postNotificationName:OrderListChanged object:nil];
            [self showPopTipsWithMessage:@"添加成功" AtView:sender inView:self.view];
        } Fail:^(NSString *errorMsg) {
            [self sendAlertAction:errorMsg];
        }];
        
    }];
    [self.view addSubview:addButton];
    
    // 立即购买
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.backgroundColor = MainColor;
    buyButton.frame = CGRectMake(leftView.width + addButton.width, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.3, 50);
    buyButton.layer.shadowOpacity = 0.8;
    buyButton.layer.shadowColor = [UIColor blackColor].CGColor;
    buyButton.layer.shadowRadius = 5;
    buyButton.layer.shadowOffset = CGSizeMake(5, 5);
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        PayOrderViewController *pay = [[PayOrderViewController alloc]initWithModel:self.model];
        [self.navigationController pushViewController:pay animated:YES];
    }];
    [self.view addSubview:buyButton];
    
    
    // FootView
    CGSize size = [self.model.goods_desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    CGFloat space = 20;
    CGFloat iconHeight = (self.view.width - 30 - 4*space)/3;
    CGFloat footHeight = size.height + 15 + 10 + iconHeight + 10;
    
    GoodDetialFootView *footView = [[GoodDetialFootView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, footHeight)];
    footView.model = self.model;
    self.tableView.tableFooterView = footView;
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
    if (indexPath.section == 0) {
        // 产品轮播图
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.scrollView];
        return cell;
    }else if (indexPath.section == 1){
        // 商品名称价格
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.nameLabel];
        [cell.contentView addSubview:self.salePriceLabel];
        //[cell.contentView addSubview:self.oldPriceLabel];
        return cell;
    }else{
        // 产品规格
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.titleLabel removeFromSuperview];
        [cell.iconView removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        GoodsStandardController *tandard = [[GoodsStandardController alloc]initWithModel:self.model];
        [self.navigationController pushViewController:tandard animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (self.view.height - 64 - 50)*0.7;
    }else if (indexPath.section == 1){
        NSString *nameStr = [NSString stringWithFormat:@"%@——%@",self.model.goods_name,self.model.goods_name_desc];
        CGSize size = [nameStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGFloat height = size.height + 10 + 30 + 20;
        return height;
    }else {
        return 55;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark - 其他方法
- (void)shareAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.title = @"一键分享，让名刹香火更旺";
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
}
- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",self.model.web_url,self.model.goods_id];
    if (clickType == WechatFriendType) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.model.goods_name_desc;
        message.description = self.model.goods_desc;
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
        message.title = self.model.goods_name_desc;
        message.description = self.model.goods_desc;
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
        [MBProgressHUD showSuccess:@"已收藏"];
    }else if (clickType == QQFriendType){
        
        NSString *title = self.model.goods_name_desc;
        NSString *description = self.model.goods_desc;
        NSString *previewImageUrl = self.model.goods_logo;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
        
    }else if (clickType == QQSpaceType){
        
        NSString *title = self.model.goods_name_desc;
        NSString *description = self.model.goods_desc;
        NSString *previewImageUrl = self.model.goods_logo;
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
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[[UIImage imageNamed:@"app_logo"],self.model.goods_name_desc,url] applicationActivities:nil];
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
        
    }
}
#pragma mark - 相关代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSArray *imageArray = cycleScrollView.imageURLStringsGroup;
    
    PYPhotoBrowseView *browerView = [[PYPhotoBrowseView alloc]init];
    browerView.imagesURL = imageArray;
    browerView.currentIndex = index;
    browerView.showDuration = 0.25;
    browerView.hiddenDuration = 0.25;
    browerView.frameToWindow = CGRectMake(0, 64, self.view.width, self.scrollView.height);
    browerView.frameFormWindow = CGRectMake(0, 64, self.view.width, self.scrollView.height);
    [browerView show];
    
}


- (SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64 - 50)*0.70) imageURLStringsGroup:@[self.model.goods_logo,self.model.goods_logo,self.model.goods_logo,self.model.goods_logo,self.model.goods_logo]];
        _scrollView.delegate = self;
        _scrollView.placeholderImage = [UIImage imageNamed:@"good_place"];
        _scrollView.autoScroll = NO;
        _scrollView.imageURLStringsGroup = @[self.model.goods_logo,self.model.goods_logo,self.model.goods_logo,self.model.goods_logo,self.model.goods_logo];
        
    }
    return _scrollView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        
        NSString *nameStr = [NSString stringWithFormat:@"%@——%@",self.model.goods_name,self.model.goods_name_desc];
        CGSize size = [nameStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.width - 30, size.height + 10)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = nameStr;
    }
    return _nameLabel;
}
- (UILabel *)salePriceLabel
{
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + 3, 70, 30)];
        _salePriceLabel.textColor = WarningColor;
        _salePriceLabel.backgroundColor = [UIColor clearColor];
        _salePriceLabel.font = [UIFont systemFontOfSize:16];
        _salePriceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.sale_price];
        
        // 富文本
        NSMutableAttributedString *graytext = [[NSMutableAttributedString alloc] initWithString:_salePriceLabel.text];
        [graytext beginEditing];
        NSRange range = NSMakeRange(1, _salePriceLabel.text.length - 1);
        [graytext addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24],NSForegroundColorAttributeName:WarningColor} range:range];
        _salePriceLabel.attributedText =  graytext;
        
    }
    return _salePriceLabel;
}
- (UILabel *)oldPriceLabel
{
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_salePriceLabel.frame) + 5, _salePriceLabel.y, 100, 30)];
        _oldPriceLabel.text = self.model.original_price;
        _oldPriceLabel.userInteractionEnabled = YES;
        _oldPriceLabel.font = [UIFont systemFontOfSize:16];
        _oldPriceLabel.textColor = RGBACOLOR(87, 87, 87, 1);
        
        // 中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleDouble]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_oldPriceLabel.text attributes:attribtDic];
        [attribtStr beginEditing];
        _oldPriceLabel.attributedText = attribtStr;
        
    }
    return _oldPriceLabel;
}


@end
