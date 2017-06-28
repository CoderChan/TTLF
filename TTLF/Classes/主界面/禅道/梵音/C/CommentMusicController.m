//
//  CommentMusicController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/6/24.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentMusicController.h"
#import "CommentBookTableCell.h"
#import <MJRefresh/MJRefresh.h>
#import "VisitUserViewController.h"


@interface CommentMusicController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

// 输入框
@property (strong,nonatomic) UITextField *textField;
// 表格
@property (strong,nonatomic) UITableView *tableView;
// 数据源
@property (strong,nonatomic) NSMutableArray *array;
// 传过来的Mp3模型
@property (strong,nonatomic) AlbumInfoModel *model;
// 头部
@property (strong,nonatomic) UIView *headView;

@end

@implementation CommentMusicController

- (instancetype)initWithModel:(AlbumInfoModel *)model WithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.model = model;
        [self.array addObjectsFromArray:array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"梵音感悟";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    // 绘制表格
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 50) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 120*CKproportion;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = self.headView;
    
    // 封面
    UIImageView *coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
    [coverImgView sd_setImageWithURL:[NSURL URLWithString:self.model.music_logo] placeholderImage:[UIImage imageWithColor:MainColor]];
    coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    [coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    coverImgView.layer.masksToBounds = YES;
    coverImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight & UIViewAutoresizingFlexibleWidth;
    coverImgView.layer.masksToBounds = YES;
    coverImgView.layer.cornerRadius = 4;
    [self.headView addSubview:coverImgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(coverImgView.frame) + 10, 20, self.view.width - 75 - 10 - 10, 25)];
    titleLabel.text = self.model.music_name;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame) + 5, titleLabel.width, 21)];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.text = [NSString stringWithFormat:@"©%@",self.model.music_author];
    [self.headView addSubview:descLabel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.array removeAllObjects];
        [[TTLFManager sharedManager].networkManager musicCommentListWithModel:self.model Success:^(NSArray *array) {
            
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            
        } Fail:^(NSString *errorMsg) {
            [self showEmptyViewWithMessage:errorMsg];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    if (self.array.count == 0) {
        [self showEmptyViewWithMessage:@"还没有人发表感悟\r成为第一个发表者？"];
    }else{
        [self.tableView reloadData];
    }
    
    // 底部输入框
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
    leftView.backgroundColor = [UIColor whiteColor];
    UIImageView *leftImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fyq_comment_edit"]];
    leftImgV.frame = CGRectMake(10, 15, 20, 20);
    [leftView addSubview:leftImgV];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.view.height - 64 - 50, self.view.width, 50)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.25f;
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.textField.height)];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"发表感悟";
    self.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textField.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.textField];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentBookTableCell *cell = [CommentBookTableCell sharedBoomCell:tableView];
    MusicCommentModel *model = self.array[indexPath.row];
    cell.UserClickMusicBlock = ^(MusicCommentModel *commentModel) {
        VisitUserViewController *visit = [[VisitUserViewController alloc]initWithUserID:commentModel.creater_id];
        [self.navigationController pushViewController:visit animated:YES];
    };
    cell.musciCommentModel = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicCommentModel *model = self.array[indexPath.row];
    CGSize size = [model.music_comment boundingRectWithSize:CGSizeMake(self.view.width - 15 - 36 - 10 - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    return size.height + 12 + 20 + 3 + 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 管理员、发布者可以删除
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    MusicCommentModel *model = self.array[indexPath.row];
    if (userModel.type == 6 || [userModel.userID isEqualToString:model.comment_id]) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 管理员、发布者可以删除
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    MusicCommentModel *model = self.array[indexPath.row];
    if (userModel.type == 6 || [userModel.userID isEqualToString:model.comment_id]) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [[TTLFManager sharedManager].networkManager deleteMusicCommentWithModel:model Success:^{
                [self.array removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            } Fail:^(NSString *errorMsg) {
                [self sendAlertAction:errorMsg];
            }];
        }];
        action.backgroundColor = WarningColor;
        return @[action];
    }else{
        return NULL;
    }
}

#pragma mark - 键盘跟随
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 40  - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 64, self.view.width, self.view.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    // 发布评论
    [MBProgressHUD showMessage:nil];
    [[TTLFManager sharedManager].networkManager commentMusicWithModel:self.model Content:textField.text Success:^(MusicCommentModel *commentModel) {
        textField.text = nil;
        [self hideMessageAction];
        [self.array insertObject:commentModel atIndex:0];
        [self.tableView reloadData];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
    return YES;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.CommentNumBlock) {
        _CommentNumBlock(self.array);
    }
}

@end
