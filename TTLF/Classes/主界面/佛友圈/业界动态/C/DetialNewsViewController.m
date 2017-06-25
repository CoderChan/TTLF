//
//  DetialNewsViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DetialNewsViewController.h"
#import "CommentNewsController.h"
#import "CommentFootView.h"
#import "SendCommentView.h"
#import <LCActionSheet.h>
#import "RightMoreView.h"
#import "PYPhotoBrowser.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>




#define BottomHeight 50

@interface DetialNewsViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,LCActionSheetDelegate,RightMoreViewDelegate,SendCommentDelegate>
{
    BOOL theBool;
    UIProgressView* myProgressView;
    NSTimer *myTimer;
}

/** webview */
@property (strong,nonatomic) UIWebView *webView;
/** 评论视图 */
@property (strong,nonatomic) SendCommentView *commendView;
/** 底部评论视图 */
@property (strong,nonatomic) CommentFootView *footView;
/** 分享的URL */
@property (copy,nonatomic) NSString *shareUrl;
/** 获取文章中的图片 */
@property (strong,nonatomic) NSMutableArray *imgUrlArray;
/** 评论的数组 */
@property (strong,nonatomic) NSMutableArray *commentArray;

@end

@implementation DetialNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加载中···";
    [self addProgressView];
    [self setupSubViews];
}
#pragma mark - 添加加载进度条
- (void)addProgressView
{
    // 仿微信进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    myProgressView.progressTintColor = RGBACOLOR(10, 160, 79, 1);
    [self.navigationController.navigationBar addSubview:myProgressView];
    
}
#pragma mark - 绘制界面
- (void)setupSubViews

{

    // 网页相关
    self.imgUrlArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(commentAction)];
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - BottomHeight)];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *url = [NSString stringWithFormat:@"%@?userID=%@&news_id=%@",self.newsModel.site,[AccountTool account].userID.base64EncodedString,self.newsModel.news_id.base64EncodedString];
    self.shareUrl = [NSString stringWithFormat:@"%@?news_id=%@",self.newsModel.site,self.newsModel.news_id.base64EncodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    // 评论视图
    __weak __block DetialNewsViewController *copySelf = self;
    self.footView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), self.view.width, BottomHeight)];
    self.footView.CommentBlock = ^(ClickType clickType) {
        if (clickType == PresentCommentViewType) {
            copySelf.commendView = [[SendCommentView alloc]initWithFrame:copySelf.view.bounds];
            copySelf.commendView.delegate = copySelf;
            copySelf.commendView.isSendIcon = NO;
            copySelf.commendView.SelectImageBlock = ^{
                // 选择评论图
                LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
                [actionSheet show];
            };
            [copySelf.view addSubview:copySelf.commendView];
        }else if (clickType == PushToCommentControlerType){
            CommentNewsController *commentVC = [CommentNewsController new];
            commentVC.newsModel = copySelf.newsModel;
            commentVC.commentArray = [NSMutableArray arrayWithArray:copySelf.commentArray];
            commentVC.CommentBlock = ^(NSArray *commentArray) {
                copySelf.commentArray = commentArray.mutableCopy;
                copySelf.footView.commentNum = commentArray.count;
            };
            [copySelf.navigationController pushViewController:commentVC animated:YES];
        }
    };
    self.footView.commentNum = self.commentArray.count;
    [self.view addSubview:self.footView];
    
    // 添加左滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        CommentNewsController *comment = [CommentNewsController new];
        comment.newsModel = self.newsModel;
        comment.commentArray = [NSMutableArray arrayWithArray:self.commentArray];
        comment.CommentBlock = ^(NSArray *commentArray) {
            copySelf.commentArray = commentArray.mutableCopy;
            copySelf.footView.commentNum = commentArray.count;
        };
        [self.navigationController pushViewController:comment animated:YES];
    }];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.webView addGestureRecognizer:recognizer];
    
    // 插入背景和提示文字
    UIView *insertView = [[UIView alloc]initWithFrame:self.webView.bounds];
    insertView.backgroundColor = RGBACOLOR(73, 75, 80, 1);
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, self.webView.width, 30)];
    topLabel.text = @"分享此文，扩散正价值观";
    topLabel.textColor = RGBACOLOR(208, 208, 208, 1);
    topLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [insertView addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, insertView.height - 37, self.webView.width, 30)];
    bottomLabel.text = @"分享此文，扩散正价值观";
    bottomLabel.textColor = RGBACOLOR(208, 208, 208, 1);
    bottomLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [insertView addSubview:bottomLabel];
    
    [self.webView insertSubview:insertView atIndex:0];
    
    
    // 获取评论数组
    [[TTLFManager sharedManager].networkManager getNewsCommentWithModel:self.newsModel Success:^(NSArray *array) {
        self.commentArray = [NSMutableArray arrayWithArray:array];
        copySelf.footView.commentNum = array.count;
    } Fail:^(NSString *errorMsg) {
        KGLog(@"获取评论错误 = %@",errorMsg);
    }];
    
}

#pragma mark - 评论的代理
- (void)sendCommentWithImage:(UIImage *)image CommentText:(NSString *)commentText
{
    [[TTLFManager sharedManager].networkManager commentNewsWithModel:self.newsModel Image:image CommentText:commentText Success:^(NewsCommentModel *model) {
        
        [MBProgressHUD showSuccess:@"评论成功"];
        [self.commentArray addObject:model];
        self.footView.commentNum = self.commentArray.count;
        
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
    }];
}


#pragma mark - 其他方法
- (void)commentAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    RightMoreView *moreView = [[RightMoreView alloc]initWithFrame:keyWindow.bounds];
    moreView.delegate = self;
    [keyWindow addSubview:moreView];
}
- (void)rightMoreViewWithClickType:(MoreItemClickType)clickType
{
    
    if (clickType == WechatFriendType) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.newsModel.news_name;
        message.description = @"佛缘生活：生活就是一场修行。";
        [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = self.shareUrl;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 0;
        [WXApi sendReq:req];
    }else if(clickType == WechatQuanType){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.newsModel.news_name;
        message.description = @"佛缘生活：生活就是一场修行。";
        [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = self.shareUrl;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = 1;
        [WXApi sendReq:req];
    }else if (clickType == StoreClickType){
        [[TTLFManager sharedManager].networkManager storeNewsWithModel:self.newsModel Success:^{
            [MBProgressHUD showSuccess:@"已收藏"];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }else if (clickType == QQFriendType){
        NSString *shareUrl = self.shareUrl;
        NSString *title = self.newsModel.news_name;
        NSString *description = @"佛缘生活：生活就是一场修行。";
        NSString *previewImageUrl = self.newsModel.news_logo;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode qqFriend = [QQApiInterface sendReq:req];
        [self sendToQQWithSendResult:qqFriend];
        
    }else if (clickType == QQSpaceType){
        NSString *shareUrl = self.shareUrl;
        NSString *title = self.newsModel.news_name;
        NSString *description = @"佛缘生活：生活就是一场修行。";
        NSString *previewImageUrl = self.newsModel.news_logo;
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode qqZone = [QQApiInterface SendReqToQZone:req];
        [self sendToQQWithSendResult:qqZone];
        
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        NSURL *url = [NSURL URLWithString:self.shareUrl];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        // 系统分享
        NSURL *url = [NSURL URLWithString:self.shareUrl];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[[UIImage imageNamed:@"app_logo"],self.newsModel.news_name,url] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (clickType == CopyUrlType){
        // 复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareUrl;
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
    }else if (clickType == RefreshType){
        // 重新加载网页
        theBool = false;
        [self addProgressView];
        [self.webView reload];
    }else if (clickType == StopLoadType){
        theBool = YES;
        [self.webView stopLoading];
    }
}
#pragma mark - 选择图片的代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            // 拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.modalPresentationStyle= UIModalPresentationPageSheet;
                imagePickerController.modalTransitionStyle = UIModalPresentationPageSheet;
                [self presentViewController:imagePickerController animated:YES completion:^{
                }];
                
            }
            break;
        }
        case 2:
        {
            // 从相册中选择
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            [imagepicker.navigationController.navigationBar setTranslucent:NO];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            imagepicker.modalPresentationStyle= UIModalPresentationPageSheet;
            imagepicker.modalTransitionStyle = UIModalPresentationPageSheet;
            imagepicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [imagepicker.navigationBar setBarTintColor:NavColor];
            [self presentViewController:imagepicker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (orgImage) {
        self.commendView.isSendIcon = YES;
        self.commendView.commentImgView.image = orgImage;
    }else{
        [MBProgressHUD showError:@"取消图片"];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    theBool = true;
    // 标题
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = self.newsModel.keywords;
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    self.imgUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.imgUrlArray.count >= 2) {
        [self.imgUrlArray removeLastObject];
    }
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    
    //添加图片可点击js
    [self.webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    KGLog(@"error = %@",error.localizedDescription);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        // path是点击的图片地址
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSInteger page = 0;
        for (int i = 0; i < self.imgUrlArray.count; i++) {
            NSString *imgUrl = self.imgUrlArray[i];
            if ([path isEqualToString:imgUrl]) {
                page = i;
            }
        }
        PYPhotosView *photosView = [PYPhotosView photosViewWithThumbnailUrls:self.imgUrlArray originalUrls:self.imgUrlArray];
        [self.view addSubview:photosView];
        
        return NO;
    }
    return YES;
}

-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.8) {
            myProgressView.progress = 0.8;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 移除 progress view
    [myProgressView removeFromSuperview];
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}


@end
