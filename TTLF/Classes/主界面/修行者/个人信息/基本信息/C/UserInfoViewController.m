//
//  UserInfoViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NavigationView.h"
#import <Masonry.h>
#import "ContentTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <LCActionSheet.h>
#import "NickNameViewController.h"
#import "CityViewController.h"
#import "StageInfoViewController.h"
#import "XLPhotoBrowser.h"
#import "PhoneViewController.h"
#import "AccountTool.h"
#import "RootNavgationController.h"



@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,LCActionSheetDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 我的头像 */
@property (strong,nonatomic) UIImageView *headImgView;
/** 昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 数据源 */
@property (strong,nonatomic) UserInfoModel *userModel;
/** 生肖的数据源 */
@property (copy,nonatomic) NSArray *animalArray;



@end



@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    
    self.array = @[@[@"头像"],@[@"昵称",@"手机号码",@"生肖",@"所在地"],@[@"摇一摇花名",@"注册时间"]];
    self.animalArray = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
    
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
    if (indexPath.section == 0) {
        // 头像
        ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.contentLabel removeFromSuperview];
        [cell.contentView addSubview:self.headImgView];
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 昵称
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.nickName;
            return cell;
        }else if (indexPath.row == 1){
            // 手机号
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.phoneNum;
            return cell;
        }else if (indexPath.row == 2){
            // 生肖
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.animal;
            return cell;
        }else{
            // 所在地
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.city;
            return cell;
        }
    }else {
        if (indexPath.row == 0) {
            // 摇一摇花名
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.stageName;
            return cell;
        }else{
            // 注册时间
            ContentTableViewCell *cell = [ContentTableViewCell sharedContentTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.userModel.register_time;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 头像
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet show];
        
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 修改昵称
            NickNameViewController *nickName = [NickNameViewController new];
            [self.navigationController pushViewController:nickName animated:YES];
        }else if (indexPath.row == 1){
            // 手机号码
            PhoneViewController *phone = [PhoneViewController new];
            [self.navigationController pushViewController:phone animated:YES];
            
        }else if (indexPath.row == 2){
            // 生肖
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex >= 1) {
                    NSString *newAnimal = self.animalArray[buttonIndex - 1];
                    [[TTLFManager sharedManager].networkManager updateAnimal:newAnimal Success:^{
                        self.userModel.animal = newAnimal;
                        [self.tableView reloadData];
                    } Fail:^(NSString *errorMsg) {
                        [MBProgressHUD showError:errorMsg];
                    }];
                }
                
            } otherButtonTitles:@"🐀.鼠",@"🐂.牛",@"🐅.虎",@"🐇.兔",@"🐲.龙",@"🐍.蛇",@"🐎.马",@"🐑.羊",@"🐒.猴",@"🐓.鸡",@"🐶.狗",@"🐖.猪", nil];
            sheet.scrolling = YES;
            sheet.visibleButtonCount = 6;
            [sheet show];
        }else{
            // 所在地
            CityViewController *cityVC = [CityViewController new];
            [self.navigationController pushViewController:cityVC animated:YES];
        }
            
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            // 摇一摇花名
            StageInfoViewController *sharek = [StageInfoViewController new];
            [self.navigationController pushViewController:sharek animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
#pragma mark - 上传头像
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
        [MBProgressHUD showMessage:@"上传中"];
        [[TTLFManager sharedManager].networkManager uploadHeadImge:orgImage Progress:^(NSProgress *progress) {
            KGLog(@"progress = %g",progress.fractionCompleted);
        } Success:^(NSString *string) {
            NSLog(@"string = %@",string);
            self.userModel.headUrl = string;
            [MBProgressHUD hideHUD];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"user_place"]];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
        
    }else {
        [MBProgressHUD showError:@"请选择图片资源"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 取消上传
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 28, 10, 60, 60)];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headUrl] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.userInteractionEnabled = YES;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [XLPhotoBrowser showPhotoBrowserWithImages:@[self.userModel.headUrl] currentImageIndex:0];
        }];
        [_headImgView addGestureRecognizer:tap];
    }
    return _headImgView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.userModel = [[TTLFManager sharedManager].userManager getUserInfo];
    [self.tableView reloadData];
}

@end
