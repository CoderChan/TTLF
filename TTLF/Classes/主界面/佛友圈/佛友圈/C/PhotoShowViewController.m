//
//  PhotoShowViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/3.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "PhotoShowViewController.h"
#import <LCActionSheet.h>

@interface PhotoShowViewController ()

{
    int tapNum; // 点击次数
}


@property (copy,nonatomic) NSArray *imageArray;


@end


@implementation PhotoShowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看图片";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
}

- (instancetype)initWithImages:(NSArray *)imageArray
{
    self = [super init];
    if (self) {
        self.imageArray = [imageArray copy];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    tapNum = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.width * self.imageArray.count, 0);
    scrollView.backgroundColor = self.view.backgroundColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width * i, 0, self.view.width, self.view.height - 64)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        UIImage *image = self.imageArray[i];
        imageV.image = image;
        [scrollView addSubview:imageV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)];
        tap.numberOfTapsRequired = YES;
        [imageV addGestureRecognizer:tap];
    }
    
}

- (void)imageClick
{
    
    if (tapNum == 1) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        tapNum = 2;
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        tapNum = 1;
    }
    
}

- (void)moreAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.DeleteIMGBlock) {
                _DeleteIMGBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } otherButtonTitles:@"删除", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}



@end
