//
//  VageNextStepController.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface VageNextStepController : SuperViewController

/** 素食封面 */
@property (strong,nonatomic) UIImage *coverImage;
/** 素食名称 */
@property (copy,nonatomic) NSString *vageName;
/** 素食故事描述 */
@property (copy,nonatomic) NSString *vageStory;


@end
