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
#import "GoodsDetialTableCell.h"
#import "PYPhotoBrowser.h"
#import "GoodsInfoModel.h"
#import "RightMoreView.h"
#import "CMPopTipView.h"
#import "PayOrderViewController.h"



@interface GoodsDetialController ()<UITableViewDelegate,UITableViewDataSource,RightMoreViewDelegate,UIWebViewDelegate>

// 商品模型
@property (strong,nonatomic) GoodsInfoModel *model;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 封面图 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 商品详细名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 商品售价 */
@property (strong,nonatomic) UILabel *salePriceLabel;
/** 商品原价 */
@property (strong,nonatomic) UILabel *oldPriceLabel;
/** UIWebView */
@property (strong,nonatomic) UIWebView *webView;


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
    self.title = self.model.goods_name;
    
    [self setupSubViews];
}

#pragma mark - 绘制表格
- (void)setupSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加表格
    self.array = @[@[@"封面轮播图"],@[@"商品名称.商品价格",@"商品说明"]];
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
    
    
    // 立即购买
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.backgroundColor = WarningColor;
    buyButton.frame = CGRectMake(leftView.width, CGRectGetMaxY(self.tableView.frame), self.view.width * 0.6, 50);
    buyButton.layer.shadowOpacity = 0.8;
    buyButton.layer.shadowColor = [UIColor blackColor].CGColor;
    buyButton.layer.shadowRadius = 5;
    buyButton.layer.shadowOffset = CGSizeMake(5, 5);
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [buyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        PayOrderViewController *pay = [[PayOrderViewController alloc]initWithModel:self.model OrderType:YES];
        [self.navigationController pushViewController:pay animated:YES];
    }];
    [self.view addSubview:buyButton];
    
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:self.model.standard];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:200*30*5*200];
    [self.webView loadRequest:request];
    
    self.tableView.tableFooterView = self.webView;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    float height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    self.webView.height = height;
    self.tableView.tableFooterView = self.webView;
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
        [cell.contentView addSubview:self.headImgView];
        return cell;
    }else{
        if (indexPath.row == 0) {
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
        } else {
            GoodsDetialTableCell *cell = [GoodsDetialTableCell sharedCell:tableView];
            cell.model = self.model;
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (self.view.height - 64 - 50)*0.7;
    }else {
        if (indexPath.row == 0) {
            NSString *nameStr = self.model.goods_name_desc;
            CGSize size = [nameStr boundingRectWithSize:CGSizeMake(self.view.width - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
            CGFloat height = size.height + 10 + 30 + 20;
            return height;
        }else{
            return 140;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor whiteColor];
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


- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64 - 50)*0.70)];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.goods_logo] placeholderImage:[UIImage imageNamed:@"goods_place"]];
        
    }
    return _headImgView;
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
        _salePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + 3, 120, 30)];
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
