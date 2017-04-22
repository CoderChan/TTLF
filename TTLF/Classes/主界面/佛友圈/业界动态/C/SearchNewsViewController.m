//
//  SearchNewsViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/20.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchNewsViewController.h"

@interface SearchNewsViewController ()

@property (copy,nonatomic) NSString *keyWord;

@end

@implementation SearchNewsViewController

- (instancetype)initWithSearchKeyWord:(NSString *)keyWord
{
    self = [super init];
    if (self) {
        self.keyWord = keyWord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索文章";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [MBProgressHUD showError:_keyWord];
}

@end
