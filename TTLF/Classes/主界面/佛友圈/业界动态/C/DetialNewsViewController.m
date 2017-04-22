//
//  DetialNewsViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/18.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DetialNewsViewController.h"
#import "CommentFootView.h"
#import "SendCommentView.h"
#import <LCActionSheet.h>
#import "RightMoreView.h"


#define BottomHeight 50

@interface DetialNewsViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,LCActionSheetDelegate,RightMoreViewDelegate>
{
    BOOL theBool;
    UIProgressView* myProgressView;
    NSTimer *myTimer;
}

/** webview */
@property (strong,nonatomic) UIWebView *webView;
/** 评论视图 */
@property (strong,nonatomic) SendCommentView *commendView;

@end

@implementation DetialNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天天阅读";
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
    myProgressView.progressTintColor = MainColor;
    [self.navigationController.navigationBar addSubview:myProgressView];
    
    
}
#pragma mark - 绘制界面
- (void)setupSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(commentAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - BottomHeight)];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsModel.source_link]];
    [self.webView loadRequest:request];
    
    // 评论视图
    __weak __block DetialNewsViewController *copySelf = self;
    CommentFootView *footView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), self.view.width, BottomHeight)];
    footView.CommentBlock = ^{
        self.commendView = [[SendCommentView alloc]initWithFrame:self.view.bounds];
        self.commendView.isSendIcon = NO;
        self.commendView.SelectImageBlock = ^{
            // 选择评论图
            LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
            [actionSheet show];
        };
        [self.view addSubview:self.commendView];
    };
    [self.view addSubview:footView];
    
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
        [MBProgressHUD showNormal:@"分享到朋友圈"];
    }else if(clickType == WechatQuanType){
        [MBProgressHUD showNormal:@"分享到微信好友"];
    }else if (clickType == StoreClickType){
        [[TTLFManager sharedManager].networkManager storeNewsWithModel:self.newsModel Success:^{
            [MBProgressHUD showSuccess:@"已收藏"];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD showError:errorMsg];
        }];
    }else if (clickType == OpenAtSafariType){
        // Safari打开
        NSURL *url = [NSURL URLWithString:self.newsModel.source_link];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else if (clickType == SystermShareType){
        NSURL *url = [NSURL URLWithString:self.newsModel.source_link];
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    }else if (clickType == CopyUrlType){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.newsModel.source_link;
        [MBProgressHUD showSuccess:@"已复制到剪切板"];
    }else if (clickType == RefreshType){
        [self.webView reload];
    }else if (clickType == NightDayMobeType){
        [MBProgressHUD showSuccess:@"夜间模式"];
    }
}
#pragma mark - 其他代理
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
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    KGLog(@"error = %@",error.localizedDescription);
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
    // because UINavigationBar is shared with other ViewControllers
    [myProgressView removeFromSuperview];
}


@end
