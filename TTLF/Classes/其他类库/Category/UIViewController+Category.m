//
//  UIViewController+Category.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (void)sendAlertAction:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}




@end
