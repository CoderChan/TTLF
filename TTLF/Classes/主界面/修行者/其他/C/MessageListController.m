//
//  MessageListController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/26.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MessageListController.h"

@interface MessageListController ()

@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self showEmptyViewWithMessage:@"还没有消息"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
