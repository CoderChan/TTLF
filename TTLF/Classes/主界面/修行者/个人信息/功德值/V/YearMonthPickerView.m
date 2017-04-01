//
//  YearMonthPickerView.m
//  FYQ
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "YearMonthPickerView.h"


@interface YearMonthPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

{
    UIButton *mengButton;
    UIView *middleView;
    
}
/** 选择器 */
@property (strong,nonatomic) UIPickerView *pickerView;
/** 数据源 */
@property (copy,nonatomic) NSMutableArray *array;
@property (copy,nonatomic) NSArray *yearArray;
@property (copy,nonatomic) NSArray *monthArray;
/** 年 */
@property (copy,nonatomic) NSString *selectYear;
/** 月 */
@property (copy,nonatomic) NSString *seletMonth;

@end

#define PickerHeight 150

@implementation YearMonthPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getCurrentDate];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)getCurrentDate
{
    NSString *dateStr = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSString *year_month = [dateStr substringWithRange:NSMakeRange(0, 7)];
    self.selectYear = [year_month substringWithRange:NSMakeRange(0, 4)];
    self.seletMonth = @"01";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // mengButton
    self.yearArray = @[@"2017"];
    self.monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    [self.array addObject:self.yearArray];
    [self.array addObject:self.monthArray];
    
    mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mengButton.backgroundColor = CoverColor;
    __weak YearMonthPickerView *copySelf = self;
    [mengButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf removeSubViews];
    }];
    [mengButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - PickerHeight - 40)];
    [self addSubview:mengButton];
    
    // 中部
    middleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - PickerHeight - 40, SCREEN_WIDTH, 40)];
//    middleView.alpha = 0.2;
    middleView.backgroundColor = [UIColor whiteColor];
    middleView.userInteractionEnabled = YES;
    [self addSubview:middleView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setFrame:CGRectMake(8, 0, 60, middleView.height)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancleBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf removeSubViews];
    }];
    [middleView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(self.width - cancleBtn.width - cancleBtn.x, 0, 60, middleView.height)];
    confirmBtn.titleLabel.font = cancleBtn.titleLabel.font;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [confirmBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.SelectMonthBlock) {
            _SelectMonthBlock(self.selectYear,self.seletMonth);
            [copySelf removeSubViews];
        }
    }];
    [middleView addSubview:confirmBtn];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, middleView.height - 1, middleView.width, 1);
    [middleView addSubview:xian];
    
    // UIPickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - PickerHeight, SCREEN_WIDTH, PickerHeight)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.alpha = 1;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerView];
    
    
    
    [self.pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.array.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.array[component] count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.array[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    // component：列  row：行
    
    if (component == 0) {
        self.selectYear = self.yearArray[row];
    }else{
        self.seletMonth = self.monthArray[row];
    }
    
}

- (void)removeSubViews
{
    [self removeFromSuperview];
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
