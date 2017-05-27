//
//  VisitUserViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/30.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VisitUserViewController.h"
#import "NormalTableViewCell.h"
#import "XLPhotoBrowser.h"
#import <LCActionSheet.h>
#import "DrawCircleView.h"
#import "PunnaListViewController.h"
#import "AboutPunnaViewController.h"
#import <Masonry.h>



@interface VisitUserViewController ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** headView */
@property (strong,nonatomic) UIView *headView;
/** 背景图 */
@property (strong,nonatomic) UIImageView *backImageView;
/** 头像 */
@property (strong,nonatomic) UIImageView *headImageView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 功德值图 */
@property (strong,nonatomic) DrawCircleView *circleView;
/** 功德值描述 */
@property (strong,nonatomic) UILabel *punnaLabel;

/** 用户ID */
@property (copy,nonatomic) NSString *userID;
/** 用户信息 */
@property (strong,nonatomic) UserInfoModel *userModel;



@end

@implementation VisitUserViewController

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self) {
        self.userID = [userID copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看功德值";
    [self setupSubViews];
    [[TTLFManager sharedManager].networkManager searchUserByUserID:self.userID Success:^(UserInfoModel *userModel) {
        self.userModel = userModel;
        self.punnaLabel.text = [NSString stringWithFormat:@"%@",userModel.punnaNum];
        self.nameLabel.text = userModel.nickName;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userBgImg] placeholderImage:[UIImage imageWithColor:RGBACOLOR(73, 75, 80, 1)]];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD showError:errorMsg];
    }];
    
    
}

- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(63, 65, 70, 1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = (self.view.height - 64) * 0.56;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headView;
    
    if ([self.userID isEqualToString:[AccountTool account].userID]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rightbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
    [cell.iconView removeFromSuperview];
    [cell.titleLabel removeFromSuperview];
    cell.backgroundColor = self.view.backgroundColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.circleView];
    return cell;;
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
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark - 选择图片
- (void)pickerImageAction
{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
    [actionSheet show];
}
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
    
    UIImage * orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
        [MBProgressHUD showMessage:nil];
        [[TTLFManager sharedManager].networkManager uploadBackImage:orgImage Progress:^(NSProgress *progress) {
            KGLog(@"上传进度 = %f",progress.fractionCompleted);
        } Success:^(NSString *string) {
            [MBProgressHUD hideHUD];
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageWithColor:RGBACOLOR(73, 75, 80, 1)]];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }else {
        [MBProgressHUD showError:@"请选择图片资源"];
    }
    
}
// 取消上传
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            PunnaListViewController *list = [PunnaListViewController new];
            [self.navigationController pushViewController:list animated:YES];
        } else if(buttonIndex == 2){
            AboutPunnaViewController *about = [AboutPunnaViewController new];
            [self.navigationController pushViewController:about animated:YES];
        }
    } otherButtonTitles:@"增长记录",@"了解功德值", nil];
    [sheet show];
}



#pragma mark - 懒加载

- (DrawCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[DrawCircleView alloc]initWithFrame:CGRectMake(0, 5, self.view.width, (self.view.height - 64) * 0.56)];
        _circleView.backgroundColor = [UIColor clearColor];
        [_circleView addSubview:self.punnaLabel];
        [self.punnaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_circleView.mas_centerX);
            make.centerY.equalTo(_circleView.mas_centerY);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
        }];
    }
    return _circleView;
}
- (UILabel *)punnaLabel
{
    if (!_punnaLabel) {
        _punnaLabel = [[UILabel alloc]init];
        self.punnaLabel.textColor = [UIColor whiteColor];
        self.punnaLabel.font = [UIFont boldSystemFontOfSize:30];
        self.punnaLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _punnaLabel;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) * 0.44)];
        _headView.backgroundColor = [UIColor clearColor];
        _headView.userInteractionEnabled = YES;
        // 添加背景图
        [_headView addSubview:self.backImageView];
        // 添加头像
        [_headView addSubview:self.headImageView];
        // 添加昵称
        [_headView addSubview:self.nameLabel];
    }
    return _headView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -25, _headView.width, _headView.height)];
        _backImageView.image = [UIImage imageWithColor:RGBACOLOR(73, 75, 80, 1)];
        _backImageView.backgroundColor = [UIColor clearColor];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            Account *account = [AccountTool account];
            if ([account.userID isEqualToString:self.userID]) {
                // 自己
                LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        // 预览大图
                        [XLPhotoBrowser showPhotoBrowserWithImages:@[_backImageView.image] currentImageIndex:0];
                    } else if(buttonIndex == 2){
                        // 更改背景图
                        [self pickerImageAction];
                    }
                } otherButtonTitles:@"预览大图",@"更改背景图", nil];
                [sheet show];
            }else{
                // 他人
                [XLPhotoBrowser showPhotoBrowserWithImages:@[_backImageView.image] currentImageIndex:0];
            }
        }];
        [_backImageView addGestureRecognizer:tap];
    }
    return _backImageView;
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 20 - 75*CKproportion, self.headView.height - 75*CKproportion, 75*CKproportion, 75*CKproportion)];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImageView.layer.borderWidth = 2;
        
        _headImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _headImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _headImageView.layer.shadowOpacity = 0.5;
        _headImageView.layer.shadowRadius = 5.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [XLPhotoBrowser showPhotoBrowserWithImages:@[_headImageView.image] currentImageIndex:0];
        }];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headView.height - 50*CKproportion , self.headView.width - 75*CKproportion - 30, 21)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    // 去掉那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复那条线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefaultPrompt];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


@end
