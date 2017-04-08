//
//  SendDynHeadView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/13.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SendDynHeadView.h"
#import <Masonry.h>

#define PlaceText @"这一刻的想法···"


@interface SendDynHeadView ()<UITextViewDelegate>



@end



@implementation SendDynHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}



- (void)setupSubViews
{
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 70)];
    self.textView.text = PlaceText;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textView];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_image"]];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame)+10, 100, 100);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ImgClickBlock) {
            _ImgClickBlock();
        }
    }];
    [self.imageView addGestureRecognizer:tap];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@2);
    }];
}

#pragma mark - 输入框代理
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PlaceText]) {
        textView.text = @"";
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PlaceText;
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
