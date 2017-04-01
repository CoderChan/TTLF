//
//  SuggestViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/1/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuggestViewController.h"
#import <Masonry.h>

#define PlaceText @"输入您的反馈，我们将为您不断改进产品质量。"

@interface SuggestViewController ()<UITextViewDelegate>
{
    NSMutableArray *buttonArray;
}
@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) UITextField *textField;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 21)];
    label.text = @"选择反馈类型：";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    // 三个选择按钮部分
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, self.view.width, 50)];
    changeView.backgroundColor = [UIColor whiteColor];
    changeView.userInteractionEnabled = YES;
    [self.view addSubview:changeView];
    
    NSArray *array = @[@"产品建议",@"程序报错"];
    buttonArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"cm2_list_checkbox"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
        [changeView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(changeView.mas_centerY);
            make.width.equalTo(@130);
            make.height.equalTo(@30);
            if (i == 0) {
                make.left.equalTo(changeView.mas_left).offset(20);
            }else{
                make.right.equalTo(changeView.mas_right).offset(-20);
            }
        }];
        
        [buttonArray addObject:button];
    }
    
    // 输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 96, self.view.width, 130)];
    self.textView.delegate = self;
    self.textView.tintColor = MainColor;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"输入您的反馈，我们将为您不断改进产品质量。";
    [self.view addSubview:self.textView];
    
    UIView *clearV = [[UIView alloc]initWithFrame:CGRectMake(0, 156+70+8, 15, 40)];
    clearV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clearV];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 156+70+8, self.view.width - 15, 40)];
    self.textField.tintColor = MainColor;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"填写您的手机或邮箱(可选)";
    self.textField.attributedText = [[NSAttributedString alloc]initWithString:self.textField.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:PlaceText]) {
        self.textView.text = @"";
    }else{
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:15];
    
}
- (void)didSelected:(UIButton *)sender
{
    for (UIButton *button in buttonArray) {
        [button setImage:[UIImage imageNamed:@"cm2_list_checkbox"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"cm2_list_checkbox_ok"] forState:UIControlStateNormal];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = PlaceText;
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor lightGrayColor];
    }else{
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)commitClick
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"谢谢您的反馈，我们将在短期内给以您回复。对于有利于产品改进的建议，我们将会纳入接下来的版本更新中。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}


@end
