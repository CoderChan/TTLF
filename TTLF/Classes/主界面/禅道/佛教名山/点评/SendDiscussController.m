//
//  SendDiscussController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SendDiscussController.h"
#import "TZImagePickerController.h"
#import "PYPhotosView.h"

@interface SendDiscussController ()<PYPhotosViewDelegate>
/** 输入框 */
@property (strong,nonatomic) YYTextView *textView;
/** 九宫格 */
@property (strong,nonatomic) PYPhotosView *publishPhotosView;

@end

@implementation SendDiscussController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.title = @"分享见闻";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendAction)];
    
    // 文字输入框
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(15, 15, self.view.width - 30, 130)];
    self.textView.placeholderText = @"欢迎去该景点旅行过的佛友分享您的见闻";
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholderFont = [UIFont systemFontOfSize:14];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5f;
    [self.view addSubview:self.textView];
    
    // 九宫格
    self.publishPhotosView = [PYPhotosView photosView];
    self.publishPhotosView.x = (SCREEN_WIDTH - PYPhotoWidth * PYPhotosMaxCol - PYPhotoMargin * (PYPhotosMaxCol + 1))/2;
    self.publishPhotosView.y = CGRectGetMaxY(self.textView.frame) + 20;
    self.publishPhotosView.images = @[].mutableCopy;
    self.publishPhotosView.delegate = self;
    [self.view addSubview:self.publishPhotosView];
    
}

#pragma mark - 选择图片的代理
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            // 之前和现在的
            NSMutableArray *photosArray = [NSMutableArray array];
            for (UIImage *image in images) {
                [photosArray addObject:image];
            }
            for (UIImage *image in photos) {
                [photosArray addObject:image];
            }
            [self.publishPhotosView reloadDataWithImages:photosArray];
        }
    };
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    KGLog(@"进入预览图片");
}



#pragma mark - 其他方法
- (void)dismissAction
{
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)sendAction
{
    
}

@end
