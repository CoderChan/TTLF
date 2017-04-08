//
//  SelectTopicView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/4/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTopicView : UIView

@property (copy,nonatomic) void (^SelectModelBlock)(SendTopicModel *topicModel);

@end
