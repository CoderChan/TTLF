//
//  BookDetialViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "BookDetialViewController.h"
#import "NormalTableViewCell.h"
#import <Masonry.h>
#import "BookTableHeadView.h"
#import "ReaderViewController.h"


@interface BookDetialViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate>

// 书籍模型
@property (strong,nonatomic) BookInfoModel *model;

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 开始阅读/添加到书架的按钮 */
@property (strong,nonatomic) UIButton *button;
/** 书籍详情 */
@property (strong,nonatomic) UITextView *bookDetialView;
/** 头部 */
@property (strong,nonatomic) BookTableHeadView *headView;

@end

@implementation BookDetialViewController


- (instancetype)initWithModel:(BookInfoModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛典详情";
    if (self.model) {
        [self setupSubViews];
    }
    
}

- (void)setupSubViews
{
    
    self.array = @[@[@"精彩书评"],@[@"开始阅读"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 80)];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    
    // 头部
    self.headView = [[BookTableHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    self.headView.model = self.model;
    self.tableView.tableHeaderView = self.headView;
    
    
    // 脚部
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 80, self.view.width, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    footView.userInteractionEnabled = YES;
    [self.view addSubview:footView];
    
    [self.button setTitle:@"开始阅读" forState:UIControlStateNormal];
    [footView addSubview:self.button];
    
}

#pragma mark - 其他方法
- (void)startReadingAction:(UIButton *)sender
{
    // 先判断该书籍本地有没有下载，没用则去下载
    
    [[TTLFManager sharedManager].networkManager downLoadBookWithModel:self.model Progress:^(NSProgress *progress) {
        NSLog(@"下载进度 = %f",progress.fractionCompleted);
    } Success:^(NSString *string) {
        [self sendAlertAction:string];
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
    }];
    
    /**
    NSString *phrase = nil;
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath = [pdfs lastObject]; assert(filePath != nil);
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    if (document) {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        readerViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"本地暂无PDF文件"];
    }
     */
    
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    else
        return YES;
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        // 查看目录
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else {
        // 开始阅读
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        //cell.contentView.backgroundColor = RGBACOLOR(102, 102, 146, 1);
        [cell.contentView addSubview:self.bookDetialView];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    } else {
        return self.tableView.height - self.headView.height - 55 - 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 0.1f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}

#pragma mark - 懒加载
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.frame = CGRectMake(25, 20, self.view.width - 50, 42);
        [_button setBackgroundColor:MainColor];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 4;
        [_button addTarget:self action:@selector(startReadingAction:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _button;
}
- (UITextView *)bookDetialView
{
    if (!_bookDetialView) {
        _bookDetialView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, self.view.width - 30, self.tableView.height - self.headView.height - 55 - 20 - 15)];
        _bookDetialView.text = self.model.book_info;
        _bookDetialView.editable = NO;
        _bookDetialView.font = [UIFont systemFontOfSize:16];
        _bookDetialView.textColor = RGBACOLOR(65, 65, 65, 1);
    }
    return _bookDetialView;
}


@end
