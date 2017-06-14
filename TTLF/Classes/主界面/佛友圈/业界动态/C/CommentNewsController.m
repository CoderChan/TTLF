//
//  CommentNewsController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/22.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "CommentNewsController.h"
#import "CommentTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CommentFootView.h"
#import <LCActionSheet.h>
#import "SendCommentView.h"
#import "VisitUserViewController.h"


#define BottomHeight 50
@interface CommentNewsController ()<UITableViewDataSource,UITableViewDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SendCommentDelegate>


/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 底部评论竖图 */
@property (strong,nonatomic) CommentFootView *footView;
/** 弹出的评论视图 */
@property (strong,nonatomic) SendCommentView *commendView;

@end

@implementation CommentNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"撰写评论";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - BottomHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager getNewsCommentWithModel:self.newsModel Success:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            [self.commentArray removeAllObjects];
            [self.commentArray addObjectsFromArray:array];
            [self hideMessageAction];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self hideMessageAction];
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    if (self.commentArray.count > 0) {
        [self.tableView reloadData];
    }else{
        [self showEmptyViewWithMessage:@"还没有数据，\r成为第一个评论者吧"];
    }
    
    // 评论视图
    __weak __block CommentNewsController *copySelf = self;
    self.footView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, BottomHeight)];
    self.footView.commentNum = self.commentArray.count;
    self.footView.CommentBlock = ^(ClickType clickType) {
        if (clickType == PresentCommentViewType) {
            copySelf.commendView = [[SendCommentView alloc]initWithFrame:copySelf.view.bounds];
            copySelf.commendView.delegate = copySelf;
            copySelf.commendView.isSendIcon = NO;
            copySelf.commendView.SelectImageBlock = ^{
                // 选择评论图
                LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
                [actionSheet show];
            };
            [copySelf.view addSubview:copySelf.commendView];
        }else if (clickType == PushToCommentControlerType){
            
        }
    };
    [self.view addSubview:self.footView];
}


#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentModel *model = self.commentArray[indexPath.row];
    CommentTableViewCell *cell = [CommentTableViewCell sharedCommentTableCell:tableView];
    cell.commentModel = model;
    self.footView.commentNum = self.commentArray.count;
    cell.UserClickBlock = ^(NewsCommentModel *commentModel) {
        VisitUserViewController *userVC = [[VisitUserViewController alloc]initWithUserID:commentModel.commenter_uid];
        [self.navigationController pushViewController:userVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentModel *model = self.commentArray[indexPath.row];
    CGFloat textHeight = [model.comment_text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    if (model.comment_pic.length > 5) {
        return 32 + textHeight + 60 + 30;
    }else{
        return 32 + textHeight + 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentModel *model = self.commentArray[indexPath.row];
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    if ([model.commenter_uid isEqualToString:[AccountTool account].userID] || userModel.type == 6) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentModel *model = self.commentArray[indexPath.row];
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    
    if ([model.commenter_uid isEqualToString:[AccountTool account].userID]) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[TTLFManager sharedManager].networkManager deleteNewsComment:model Success:^{
                        [self.commentArray removeObjectAtIndex:indexPath.row];
                        self.footView.commentNum = self.commentArray.count;
                        if (self.CommentBlock) {
                            _CommentBlock(self.commentArray);
                        }
                        [self.tableView reloadData];
                    } Fail:^(NSString *errorMsg) {
                        [self sendAlertAction:errorMsg];
                    }];
                }
            } otherButtonTitles:@"删除评论", nil];
            sheet.destructiveButtonIndexSet = [NSSet setWithObjects:@1, nil];
            [sheet show];
        }];
        action.backgroundColor = WarningColor;
        return @[action];
    }else if (userModel.type == 6){
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // 管理员删除
                    [[TTLFManager sharedManager].networkManager adminDeleteNewsComment:model Success:^{
                        [self.commentArray removeObjectAtIndex:indexPath.row];
                        self.footView.commentNum = self.commentArray.count;
                        if (self.CommentBlock) {
                            _CommentBlock(self.commentArray);
                        }
                        [self.tableView reloadData];
                    } Fail:^(NSString *errorMsg) {
                        [self sendAlertAction:errorMsg];
                    }];
                }
            } otherButtonTitles:@"删除评论", nil];
            sheet.destructiveButtonIndexSet = [NSSet setWithObjects:@1, nil];
            [sheet show];
        }];
        action.backgroundColor = WarningColor;
        return @[action];
    }else{
        return NULL;
    }
    
}
#pragma mark - 评论的代理
- (void)sendCommentWithImage:(UIImage *)image CommentText:(NSString *)commentText
{
    [[TTLFManager sharedManager].networkManager commentNewsWithModel:self.newsModel Image:image CommentText:commentText Success:^(NewsCommentModel *model) {
        [MBProgressHUD showSuccess:@"评论成功"];
        [self.commentArray insertObject:model atIndex:0];
        self.footView.commentNum = self.commentArray.count;
        [self.tableView reloadData];
        [self hideMessageAction];
        if (self.CommentBlock) {
            _CommentBlock(self.commentArray);
        }
    } Fail:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 选择图片的代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            // 拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.modalPresentationStyle= UIModalPresentationPageSheet;
                imagePickerController.modalTransitionStyle = UIModalPresentationPageSheet;
                [self presentViewController:imagePickerController animated:YES completion:^{
                }];
                
            }
            break;
        }
        case 2:
        {
            // 从相册中选择
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            [imagepicker.navigationController.navigationBar setTranslucent:NO];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            imagepicker.modalPresentationStyle= UIModalPresentationPageSheet;
            imagepicker.modalTransitionStyle = UIModalPresentationPageSheet;
            imagepicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [imagepicker.navigationBar setBarTintColor:NavColor];
            [self presentViewController:imagepicker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (orgImage) {
        self.commendView.isSendIcon = YES;
        self.commendView.commentImgView.image = [orgImage stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    }else{
        [MBProgressHUD showError:@"暂不支持此类型的图片"];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
