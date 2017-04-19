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


#define BottomHeight 50

@interface DetialNewsViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,LCActionSheetDelegate>

/** webview */
@property (strong,nonatomic) UIWebView *webView;
/** 评论视图 */
@property (strong,nonatomic) SendCommentView *commendView;

@end

@implementation DetialNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天天阅读";
    [self setupSubViews];
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fo.ifeng.com/a/20170418/44575301_0.shtml"]];
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
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    KGLog(@"error = %@",error.localizedDescription);
}

@end
