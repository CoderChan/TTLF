//
//  VisitUserViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VisitUserViewController.h"

@interface VisitUserViewController ()

/** 用户ID */
@property (copy,nonatomic) NSString *userID;

@end

@implementation VisitUserViewController

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        self.userID = [userID copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.userID;
}

@end
