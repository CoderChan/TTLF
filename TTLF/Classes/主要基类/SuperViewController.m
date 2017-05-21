//
//  SuperViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/3/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import <Masonry.h>



@interface SuperViewController ()

@property (strong,nonatomic) UILabel *messageLabel;

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackColor;
    
}

#pragma mark - 数据异常时的处理
- (void)showEmptyViewWithMessage:(NSString *)message
{
    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((70 * CKproportion));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
    }];
    self.messageLabel.hidden = NO;
    self.messageLabel.text = message;
}

- (void)hideMessageAction
{
    self.messageLabel.hidden = YES;
}

#pragma mark - 通用设置
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)sendToQQWithSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            [self sendAlertAction:@"APP未注册"];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            
            [self sendAlertAction:@"发送参数错误"];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            
            [self sendAlertAction:@"未安装手QQ"];
            
            break;
        }
        case EQQAPITIMNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装TIM" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        case EQQAPITIMNOTSUPPORTAPI:
        {
            
            [self sendAlertAction:@"API接口不支持"];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            
            [self sendAlertAction:@"发送失败"];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            [self sendAlertAction:@"当前QQ版本太低，需要更新"];
            break;
        }
        case ETIMAPIVERSIONNEEDUPDATE:
        {
            
            [self sendAlertAction:@"当前QQ版本太低，需要更新"];
            
            break;
        }
        default:
        {
            break;
        }
    }
}
#pragma mark - 懒加载
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont boldSystemFontOfSize:24];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = RGBACOLOR(108, 108, 108, 1);
        _messageLabel.hidden = YES;
        
    }
    return _messageLabel;
}

@end
