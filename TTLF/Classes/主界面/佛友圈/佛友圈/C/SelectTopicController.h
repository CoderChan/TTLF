//
//  SelectTopicController.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/1.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


@interface SelectTopicController : SuperViewController

@property (copy,nonatomic) void (^SelectModelBlock)(SendTopicModel *topicModel);

@end
