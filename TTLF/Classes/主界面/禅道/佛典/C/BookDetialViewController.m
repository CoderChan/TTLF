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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佛典详情";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    self.array = @[@[@"查看目录"],@[@"开始阅读"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 80)];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    
    
    // 头部
    self.headView = [[BookTableHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
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
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to first PDF file
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    if (document) {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        readerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:readerViewController animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"本地暂无PDF文件"];
    }
    
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
        _button.frame = CGRectMake(25, 20, self.view.width - 50, 40);
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
        _bookDetialView.text = @"     导语：妙法莲华经(Saddharmapundarika-sutra) ，简称《法华经》， 在古印度、尼泊尔等地长期流行。在克什米尔、尼泊尔和中国新疆、西藏等地有40多种梵文版本，分为尼泊尔体系、克什米尔体系（基尔基特）和新疆体系。尼泊尔体系版本约为11世纪后作品，保持完整，已出版5种校订本。1983年北京民族文化宫图书馆用珂罗版彩色复制出版了由尼泊尔传入、珍藏于西藏萨迦寺的法华经。《妙法莲华经》是佛陀释迦牟尼晚年说教，宣讲内容至高无上，明示不分贫富贵贱、人人皆可成佛。关键词“妙法莲华”。“妙法”指的是一乘法、不二法；“莲华”比喻“妙”在什么地方，第一是花果同时，第二是出淤泥而不染，第三是内敛不露。\n《法华经》是释迦牟尼佛晚年在王舍城灵鷲山所说，为大乘佛教初期经典之一。《法华经》成立年代约纪元前後，最晚不迟于公元1世纪，因为龙树菩萨(公元150-250)的著作《中论》、《大智度论》已引用本经文义。另外《大泥洹经》、《大般涅槃经》、《优婆塞戒经》、《大乘本生心地观经》、《大佛顶首楞严经》等诸经皆列举本经经名并援引经中文义，可见本经之成立年代较以上诸经为早。七卷，或八卷，后秦鸠摩罗什译";
        _bookDetialView.editable = NO;
        _bookDetialView.font = [UIFont systemFontOfSize:16];
        _bookDetialView.textColor = RGBACOLOR(65, 65, 65, 1);
    }
    return _bookDetialView;
}


@end
