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


#define BottomHeight 50
@interface CommentNewsController ()<UITableViewDataSource,UITableViewDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SendCommentDelegate>

/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
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
    self.array = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - BottomHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 160;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[TTLFManager sharedManager].networkManager getNewsCommentWithModel:self.newsModel Success:^(NSArray *array) {
            [self.tableView.mj_header endRefreshing];
            [self.array removeAllObjects];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        } Fail:^(NSString *errorMsg) {
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithMessage:errorMsg];
        }];
    }];
    
    
    // 评论视图
    __weak __block CommentNewsController *copySelf = self;
    CommentFootView *footView = [[CommentFootView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.width, BottomHeight)];
    footView.CommentBlock = ^(ClickType clickType) {
        if (clickType == PresentCommentViewType) {
            self.commendView = [[SendCommentView alloc]initWithFrame:self.view.bounds];
            self.commendView.delegate = self;
            self.commendView.isSendIcon = NO;
            self.commendView.SelectImageBlock = ^{
                // 选择评论图
                LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
                [actionSheet show];
            };
            [self.view addSubview:self.commendView];
        }else if (clickType == PushToCommentControlerType){
            
        }
    };
    [self.view addSubview:footView];
}



#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
//    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [CommentTableViewCell sharedCommentTableCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
#pragma mark - 评论的代理
- (void)sendCommentWithImage:(UIImage *)image CommentText:(NSString *)commentText
{
    [[TTLFManager sharedManager].networkManager commentNewsWithModel:self.newsModel Image:image CommentText:commentText Success:^{
        [MBProgressHUD showSuccess:@"评论成功"];
    } Fail:^(NSString *errorMsg) {
        [self sendAlertAction:errorMsg];
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
