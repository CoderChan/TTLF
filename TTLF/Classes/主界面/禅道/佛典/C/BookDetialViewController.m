//
//  BookDetialViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookDetialViewController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>
#import "BookTableHeadView.h"
#import "ReaderViewController.h"
#import "BookCacheManager.h"
#import "RightMoreView.h"
#import "CommentBookController.h"


@interface BookDetialViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate,RightMoreViewDelegate>

// 书籍模型
@property (strong,nonatomic) BookInfoModel *model;

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 开始阅读/添加到书架的按钮 */
@property (strong,nonatomic) UIButton *button;
/** 书籍详情 */
@property (strong,nonatomic) UITextView *bookDetialView;
/** 头部 */
@property (strong,nonatomic) BookTableHeadView *headView;

@end

@implementation BookDetialViewController


- (instancetype)initWithModel:(BookInfoModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛典详情";
    if (self.model) {
        [self setupSubViews];
    }
    
}

- (void)setupSubViews
{
    
    self.array = @[@[@"精彩书评"],@[@"开始阅读"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 80)];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    // 头部
    self.headView = [[BookTableHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    self.headView.model = self.model;
    self.tableView.tableHeaderView = self.headView;
    
    
    // 脚部
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 80, self.view.width, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.userInteractionEnabled = YES;
    [self.view addSubview:footView];
    
    
    [footView addSubview:self.button];
    
    // 分享事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
}


#pragma mark - 其他方法
- (void)startReadingAction:(UIButton *)sender
{
    // 先判断该书籍本地有没有下载，有就直接阅读，没用则去下载
    NSString *filePath = [self searchFilePathByFileName:self.model.name];
    if (filePath) {
        // 有缓存  直接阅读
        [self readPDFFileAction:filePath];
    }else{
        // 去下载，先判断网络
        [self networkingType:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusUnknown) {
                [MBProgressHUD showError:@"未知网络"];
            }else if (status == AFNetworkReachabilityStatusNotReachable){
                [MBProgressHUD showError:@"网络未连接"];
            }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
                NSString *title = [NSString stringWithFormat:@"没有WiFi，当前网络将消耗您%@MB流量，是否继续？",[self returnMBWithbyte:self.model.book_size]];
                [self showTwoAlertWithMessage:title ConfirmClick:^{
                    [self downLoadPDFFileAction];
                }];
            }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
                // wifi网络 直接下载并阅读
                [self downLoadPDFFileAction];
            }
        }];
        
    }
    
}
// 开始下载电子书
- (void)downLoadPDFFileAction
{
    [MBProgressHUD showMessage:nil];
    [[TTLFManager sharedManager].networkManager downLoadBookWithModel:self.model Progress:^(NSProgress *progress) {
        NSLog(@"下载进度 = %f",progress.fractionCompleted);
    } Success:^(NSString *string) {
        
        [MBProgressHUD hideHUD];
        [self readPDFFileAction:string];
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
}

// 判断文件是否已经在沙盒中已经存在？
- (NSString *)searchFilePathByFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    if (result) {
        return filePath;
    }else{
        return nil;
    }
}

- (void)readPDFFileAction:(NSString *)filePath
{
    NSString *phrase = nil;
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    if (document) {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        readerViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"本地暂无PDF文件"];
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
    [self.button setTitle:@"开始阅读" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    else
        return YES;
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
    if (indexPath.section == 0){
        // 精彩书评
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else {
        // 开始阅读
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        //cell.contentView.backgroundColor = RGBACOLOR(102, 102, 146, 1);
        [cell.contentView addSubview:self.bookDetialView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CommentBookController *comment = [[CommentBookController alloc]initWithModel:self.model];
        [self.navigationController pushViewController:comment animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    } else {
        return self.tableView.height - self.headView.height - 55 - 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 0.1f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}

#pragma mark - 分享PDF
- (void)shareAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
    
}

- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    NSString *shareURL = [NSString stringWithFormat:@"%@&userID=%@",self.model.web_url,[AccountTool account].userID.base64EncodedString];
    if (![shareURL containsString:@"http://"]) {
        shareURL = [NSString stringWithFormat:@"%@%@",@"http://",shareURL];
    }
    
    if (clickType == WechatFriendType) {
        NSData *imageData = UIImageJPEGRepresentation(self.headView.bookCoverImgView.image, 0.01);
        NSInteger len = imageData.length / 1024;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.model.book_name;
        message.description = self.model.book_info;
        if (len > 32) {
            [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        }else{
            [message setThumbData:imageData];
        }
        
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareURL;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if(clickType == WechatQuanType){
        NSData *imageData = UIImageJPEGRepresentation(self.headView.bookCoverImgView.image, 0.01);
        NSInteger len = imageData.length / 1024;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.model.book_name;
        message.description = self.model.book_info;
        if (len > 32) {
            [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        }else{
            [message setThumbData:imageData];
        }
        
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareURL;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (clickType == StoreClickType){
        NSData *imageData = UIImageJPEGRepresentation(self.headView.bookCoverImgView.image, 0.01);
        NSInteger len = imageData.length / 1024;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.model.book_name;
        message.description = self.model.book_info;
        if (len > 32) {
            [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        }else{
            [message setThumbData:imageData];
        }
        
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = shareURL;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 2;
        [WXApi sendReq:req];
        
    }else if (clickType == QQFriendType){
        NSString *shareUrl = shareURL;
        NSString *title = self.model.book_name;
        NSString *description = self.model.book_info;
        NSString *previewImageUrl = self.model.book_logo;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
    }else if (clickType == QQSpaceType){
        NSString *shareUrl = shareURL;
        NSString *title = self.model.book_name;
        NSString *description = self.model.book_info;
        NSString *previewImageUrl = self.model.book_logo;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        
        NSURL *url = [NSURL URLWithString:shareURL];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        // 系统分享
        NSURL *url = [NSURL URLWithString:shareURL];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[self.headView.bookCoverImgView.image,self.model.book_name,url] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (clickType == CopyUrlType){
        // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = shareURL;
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
    }else if (clickType == RefreshType){
        // 重新加载网页
        
    }else if (clickType == StopLoadType){
        // 停止加载
    }
}



#pragma mark - 懒加载
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.frame = CGRectMake(25, 20, self.view.width - 50, 42);
        [_button setBackgroundColor:MainColor];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 4;
        NSString *filePath = [self searchFilePathByFileName:self.model.name];
        if (filePath) {
            // 已缓存，立即阅读
            [_button setTitle:@"立即阅读" forState:UIControlStateNormal];
        }else{
            // 没有缓存，添加到书架（2.5MB）
            NSString *title = [NSString stringWithFormat:@"添加到书架(%@MB)",[self returnMBWithbyte:self.model.book_size]];
            [_button setTitle:title forState:UIControlStateNormal];
        }
        [_button addTarget:self action:@selector(startReadingAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _button;
}
- (NSString *)returnMBWithbyte:(NSString *)byte
{
    CGFloat byteFloat = [byte floatValue];
    CGFloat mbFloat = byteFloat/1024/1024;
    NSString *mb = [NSString stringWithFormat:@"%.2f",mbFloat];
    return mb;
}
- (UITextView *)bookDetialView
{
    if (!_bookDetialView) {
        _bookDetialView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, self.view.width - 30, self.tableView.height - self.headView.height - 55 - 20 - 15)];
        _bookDetialView.text = self.model.book_info;
        _bookDetialView.editable = NO;
        _bookDetialView.font = [UIFont systemFontOfSize:16];
        _bookDetialView.textColor = RGBACOLOR(65, 65, 65, 1);
    }
    return _bookDetialView;
}


@end
