//
//  NormalWebViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NormalWebViewController.h"
#import "PYPhotoBrowser.h"
#import "ShareView.h"
#import "UIView+Toast.h"
#import <Social/Social.h>


@interface NormalWebViewController ()<UIWebViewDelegate,ShareViewDelegate>
{
    BOOL theBool;
    UIProgressView* myProgressView;
    NSTimer *myTimer;
}
/** w网页控件 */
@property (strong,nonatomic) UIWebView *webView;
/** 网页地址 */
@property (copy,nonatomic) NSString *urlStr;
/** 获取文章中的图片 */
@property (strong,nonatomic) NSMutableArray *imgUrlArray;

@end

@implementation NormalWebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        self.urlStr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self addProgressView];
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
    myProgressView.progressTintColor = GreenColor;
    [self.navigationController.navigationBar addSubview:myProgressView];
    
}
#pragma mark - 绘制界面
- (void)setupSubViews

{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(commentAction)];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    
    // 插入背景和提示文字
    UIView *insertView = [[UIView alloc]initWithFrame:self.webView.bounds];
    insertView.backgroundColor = RGBACOLOR(73, 75, 80, 1);
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, self.webView.width, 30)];
    topLabel.text = @"点击分享，扩散正价值观";
    topLabel.textColor = RGBACOLOR(208, 208, 208, 1);
    topLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [insertView addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, insertView.height - 37, self.webView.width, 30)];
    bottomLabel.text = @"点击分享，扩散正价值观";
    bottomLabel.textColor = RGBACOLOR(208, 208, 208, 1);
    bottomLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [insertView addSubview:bottomLabel];
    
    [self.webView insertSubview:insertView atIndex:0];
    
}
#pragma mark - 分享的方法
- (void)commentAction
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ShareView *sharedView = [[ShareView alloc]initWithFrame:keyWindow.bounds];
    sharedView.delegate = self;
    [keyWindow addSubview:sharedView];
}

- (void)shareViewClickWithType:(ShareViewClickType)type
{
    NSString *url = self.urlStr;
    NSString *docuTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *title = docuTitle.length > 1 ? docuTitle : @"推荐下载：佛缘生活";
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
        // 新浪微博
        BOOL isAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo];
        if (isAvailable == NO) {
            [MBProgressHUD showError:@"应用不支持当前平台分享"];
            return;
        }
        SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [composeVc setInitialText:descStr];
        [composeVc addImage:[UIImage imageNamed:@"app_logo"]];
        [composeVc addURL:[NSURL URLWithString:OfficalWebURL]];
        [self presentViewController:composeVc animated:YES completion:^{
            
        }];
        composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
            if (reulst == SLComposeViewControllerResultDone) {
                //                [MBProgressHUD showSuccess:@"分享成功"];
            } else {
                //                [MBProgressHUD showError:@"分析失败"];
            }
        };
        
    }else if (type == SysterShareType){
        // 系统分享
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[image,title,[NSURL URLWithString:url]] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (type == WechatStoreType){
        // 微信收藏
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


#pragma mark - 网页代理
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
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title.length >= 1 ? title : @"查看详情";
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


@end
