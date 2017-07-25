//
//  TuiguangViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "TuiguangViewController.h"
#import "UIView+Toast.h"
#import <Social/Social.h>
#import "PYPhoto.h"
#import "UIButton+Category.h"
#import "CMPopTipView.h"
#import "XLPhotoBrowser.h"


#define TextPlace @"推荐下载：佛缘生活APP。附谍照。"

static NSString *const SLServiceTypeWechat = @"com.tencent.xin.sharetimeline";
static NSString *const SLServiceTypeQQ = @"com.tencent.mqq.ShareExtension";
static NSString *const SLServiceTypeAlipay = @"com.alipay.iphoneclient.ExtensionSchemeShare";
static NSString *const SLServiceTypeSms = @"com.apple.UIKit.activity.Message";
static NSString *const SLServiceTypeEmail = @"com.apple.UIKit.activity.Mail";


@interface TuiguangViewController ()

// 文字说明
@property (strong,nonatomic) UITextView *descTextView;
// 图片数组
@property (strong,nonatomic) NSMutableArray *imageArray;
// 装着点击按钮的数组
@property (strong,nonatomic) NSMutableArray *buttonArray;
// 选择分享的平台
@property (assign,nonatomic) ShareType type;


@end

@implementation TuiguangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"弘扬";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.type = WechatType;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(tipAction)];
    
    // 文字说明
    self.descTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.view.width - 40, 85*CKproportion)];
    self.descTextView.editable = NO;
    self.descTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descTextView.text = @"为方便广大佛友，开发团队耗时多年打造精品应用佛缘生活APP，如果您身边有佛学人士，我们欢迎您一键转发，此样式为九宫格格式，适合发送到朋友圈、QQ空间。我们致力于营造良好的佛学环境和开放的交流空间。为此我们将赠送您1点功德值，每日最多2次。谢谢！";
    self.descTextView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.descTextView];
    
    self.imageArray = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        NSString *imgName = [NSString stringWithFormat:@"share_%d",i];
        UIImage *image = [UIImage imageNamed:imgName];
        [self.imageArray addObject:image];
    }
    
    
    // 九宫格
    
    CGFloat space = 5;
    CGFloat width = (self.view.width - 30*CKproportion * 2 - space * 4)/3;
    CGFloat height = width;
    CGRect frame;
    for (int i = 0; i < self.imageArray.count; i++) {
        
        frame.origin.x = (i%3) * (frame.size.width + space) + space + 30*CKproportion;
        frame.origin.y = CGRectGetMaxY(self.descTextView.frame) + floor(i/3) * (frame.size.height + space) + 10;
        frame.size.width = width;
        frame.size.height = height;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.imageArray[i]];
        imageView.backgroundColor = NavColor;
        imageView.userInteractionEnabled = YES;
        imageView.frame = frame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setContentScaleFactor:[UIScreen mainScreen].scale];
        imageView.layer.masksToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [XLPhotoBrowser showPhotoBrowserWithImages:self.imageArray currentImageIndex:i];
        }];
        [imageView addGestureRecognizer:tap];
        
    }
    
    // 微信、QQ
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatButton.frame = CGRectMake(self.view.width/2 - 80 - 20, CGRectGetMaxY(self.descTextView.frame) + 30*CKproportion + height * 3 + space * 4, 80*CKproportion, 80*CKproportion);
    wechatButton.backgroundColor = GreenColor;
    [wechatButton setTitle:@"微信" forState:UIControlStateNormal];
    [wechatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wechatButton setImage:[UIImage imageNamed:@"wechat_white"] forState:UIControlStateNormal];
    [wechatButton setImage:[UIImage imageNamed:@"wechat_white"] forState:UIControlStateHighlighted];
    [wechatButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        for (UIButton *button in self.buttonArray) {
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
            button.backgroundColor = self.view.backgroundColor;
            
        }
        // 选择微信分享
        sender.backgroundColor = GreenColor;
        [sender setImage:[UIImage imageNamed:@"wechat_white"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.type = WechatType;
    }];
    wechatButton.titleLabel.font = [UIFont systemFontOfSize:15];
    wechatButton.layer.masksToBounds = YES;
    wechatButton.layer.cornerRadius = 40*CKproportion;
    wechatButton.layer.borderColor = GreenColor.CGColor;
    wechatButton.layer.borderWidth = 2.f;
    [self.view addSubview:wechatButton];
    [wechatButton centerImageAndTitle:3];
    
    
    UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QQButton.frame = CGRectMake(self.view.width/2 + 20, wechatButton.y, 80*CKproportion, 80*CKproportion);
    QQButton.backgroundColor = self.view.backgroundColor;
    [QQButton setTitle:@"QQ" forState:UIControlStateNormal];
    QQButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [QQButton setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [QQButton setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateHighlighted];
    [QQButton setTitleColor:GreenColor forState:UIControlStateNormal];
    [QQButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *sender) {
        for (UIButton *button in self.buttonArray) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            [wechatButton setImage:[UIImage imageNamed:@"share_wechatFri"] forState:UIControlStateNormal];
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
        }
        sender.backgroundColor = GreenColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 选择QQ分享
        self.type = QQType;
    }];
    QQButton.layer.masksToBounds = YES;
    QQButton.layer.cornerRadius = 40*CKproportion;
    QQButton.layer.borderColor = GreenColor.CGColor;
    QQButton.layer.borderWidth = 2.f;
    [self.view addSubview:QQButton];
    [QQButton centerImageAndTitle:3];
    
    [self.buttonArray addObject:wechatButton];
    [self.buttonArray addObject:QQButton];
    
    // 一键转发
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = GreenColor;
    [sendButton setTitle:@"一键转发" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(shareToWechatAction) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(30, self.view.height - 40 - 30*CKproportion - 64, self.view.width - 60, 44)];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 4;
    [self.view addSubview:sendButton];
    
}

- (void)shareToWechatAction
{
    
    
    NSString *shareType;
    if (self.type == WechatType) {
        shareType = SLServiceTypeWechat;
    }else{
        shareType = SLServiceTypeQQ;
    }
    
    BOOL isAvailable = [SLComposeViewController isAvailableForServiceType:shareType];
    if (isAvailable == NO) {
        [MBProgressHUD showError:@"应用不支持当前平台分享"];
        return;
    }
    
    UIPasteboard *pasted = [UIPasteboard generalPasteboard];
    [pasted setString:TextPlace];
    [MBProgressHUD showNormal:@"已复制到剪贴板"];
    
    
    // 创建分享控制器
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:shareType];
    [composeVc setInitialText:TextPlace];
    for (int i = 0; i < self.imageArray.count; i++) {
        
        UIImage *image = [self addWaterImage:self.imageArray[i] Name:@"©佛缘生活"];
        
        [composeVc addImage:image];
    }
    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
        if (reulst == SLComposeViewControllerResultDone) {
            [[TTLFManager sharedManager].networkManager shareNineTableCompletion:^{
                [self sendAlertAction:@"感谢您的转发，您可查看功德值增长变化。"];
            }];
        } else {
            [MBProgressHUD showError:@"分享失败"];
        }
    };
    
    [self presentViewController:composeVc animated:YES completion:^{
        
    }];
}

// 提示
- (void)tipAction
{
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithTitle:nil message:@"由于苹果手机的限制性，您在转发到微信朋友圈、QQ空间之前必须手动复制文字到文本框。"];
    popTipView.shouldEnforceCustomViewPadding = YES;
    popTipView.backgroundColor = RGBACOLOR(25, 35, 45, 1);
    popTipView.animation = CMPopTipAnimationPop;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:NO atTimeInterval:5];
    popTipView.textColor = [UIColor whiteColor];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
