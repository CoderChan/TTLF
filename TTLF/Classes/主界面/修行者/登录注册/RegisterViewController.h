//
//  RegisterViewController.h
//  YLRM
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef void (^CompletionVlock)();

@interface RegisterViewController : SuperViewController

@property (copy,nonatomic) void (^AccountBlock)(NSString *phone,NSString *pass);

@end
