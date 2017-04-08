//
//  SendDynViewController.m
//  FYQ
//
//  Created by Chan_Sir on 2017/2/28.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SendDynViewController.h"
#import "SelectLocaltionController.h"
#import "SendDynTableCell.h"
#import "SendDynHeadView.h"
#import "SelectTopicController.h"
#import <LCActionSheet.h>
#import "PhotoShowViewController.h"
#import "XLProgressView.h"



@interface SendDynViewController ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 话题模型 */
@property (strong,nonatomic) SendTopicModel *topicModel;
/** 坐标 */
//@property (strong,nonatomic) AMapPOI *poiModel;
/** 头部 */
@property (strong,nonatomic) SendDynHeadView *headView;

/** 是否要上传图片 */
@property (assign,nonatomic) BOOL isSendIMG;
/** 是否发送地址 */
@property (assign,nonatomic) BOOL isSendLocation;
/** 是否使用匿名身份 */
@property (strong,nonatomic) UISwitch *switchView;


@end

@implementation SendDynViewController

#pragma mark - 绘制视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_send"] style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    
    self.isSendIMG = NO;
    self.isSendLocation = NO;
    
    self.array = @[@[@"选择话题"],@[@"所在位置",@"匿名发送"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.headView = [[SendDynHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    __weak SendDynViewController *copySelf = self;
    self.headView.ImgClickBlock = ^(){
        [copySelf.view endEditing:YES];
        if (copySelf.isSendIMG) {
            PhotoShowViewController *photoShow = [[PhotoShowViewController alloc]initWithImages:@[copySelf.headView.imageView.image]];
            photoShow.DeleteIMGBlock = ^(){
                copySelf.headView.imageView.image = [UIImage imageNamed:@"add_image"];
                copySelf.isSendIMG = NO;
            };
            [copySelf.navigationController pushViewController:photoShow animated:YES];
        }else{
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
            [sheet show];
        }
    };
    self.tableView.tableHeaderView = self.headView;
    
    UIView *insertView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_WIDTH == 375) {
        insertView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg_ip6"]];
    }else{
        insertView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg"]];
    }
    insertView.backgroundColor = [UIColor whiteColor];
    [self.tableView insertSubview:insertView atIndex:0];
    
}

- (void)sendAction
{
    
    if (!self.topicModel) {
        [MBProgressHUD showError:@"请选择话题"];
        return;
    }
    
    NSString *locationJson;
    if (self.isSendLocation) {
#warning 格式化地理信息
//        NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
//        [locationDict setValue:@"address" forKey:self.poiModel.address];
//        [locationDict setValue:@"latitude" forKey:[NSString stringWithFormat:@"%f",self.poiModel.location.latitude]];
//        [locationDict setValue:@"longitude" forKey:[NSString stringWithFormat:@"%f",self.poiModel.location.longitude]];
//        locationJson = [self toJsonStr:locationDict];
    }else{
        locationJson = @"";
    }
    
    if (self.isSendIMG) {
        // 有图
        [MBProgressHUD showMessage:@"发送中···"];
        [[TTLFManager sharedManager].networkManager sendImgDyn:self.headView.imageView.image Topic:self.topicModel Content:self.headView.textView.text LocationJson:locationJson IsNoname:!self.switchView.on Progress:^(NSProgress *progress) {
//            NSLog(@"progress = %f",progress.fractionCompleted);
        } Success:^(NSString *string) {
            [self.view endEditing:YES];
            [MBProgressHUD hideHUD];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }else{
        // 无图的
        [MBProgressHUD showMessage:@"发送中···"];
        [[TTLFManager sharedManager].networkManager sendTextDynWithTopic:self.topicModel Content:self.headView.textView.text LocationJson:locationJson IsNoname:!self.switchView.on Success:^(NSString *string) {
            
            [MBProgressHUD hideHUD];
            [self.view endEditing:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } Fail:^(NSString *errorMsg) {
            [MBProgressHUD hideHUD];
            [self sendAlertAction:errorMsg];
        }];
    }
}

#pragma mark - 相关代理方法
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
            
        }
        case 2:
        {
            // 从相册中选择
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            [imagepicker.navigationController.navigationBar setTranslucent:NO];
            imagepicker.modalPresentationStyle= UIModalPresentationPageSheet;
            imagepicker.modalTransitionStyle = UIModalPresentationPageSheet;
            imagepicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [imagepicker.navigationBar setBarTintColor:NavColor];
            [self presentViewController:imagepicker animated:YES completion:nil];
            break;
            
            break;
        }
        default:
            break;
    }

}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * orgImage = info[UIImagePickerControllerOriginalImage];
    
    if (orgImage) {
        
        [self.headView.imageView setImage:orgImage];
        self.isSendIMG = YES;
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [MBProgressHUD showError:@"请选择图片资源"];
    }
}


#pragma mark - 取消上传
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
    NSArray *iconArray = @[@[@"send_topic"],@[@"send_location_normal",@"send_noname_normal"]];
    if (indexPath.section == 0) {
        SendDynTableCell *cell = [SendDynTableCell sharedSendDynTableCell:tableView];
        
        cell.contentLabel.text = self.topicModel.topic_name;
        cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
        cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    }else{
        if (indexPath.row == 0) {
            SendDynTableCell *cell = [SendDynTableCell sharedSendDynTableCell:tableView];
            if (self.isSendLocation) {
                cell.iconView.image = [UIImage imageNamed:@"send_location_highted"];
            }else{
                cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
            }
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = @"中南海";
            return cell;
        }else{
            SendDynTableCell *cell = [SendDynTableCell sharedSendDynTableCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.contentView addSubview:self.switchView];
            cell.titleLabel.text = self.array[indexPath.section][indexPath.row];
            if (self.switchView.on) {
                cell.iconView.image = [UIImage imageNamed:@"send_noname_highted"];
            }else{
                cell.iconView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        SelectTopicController *vc = [SelectTopicController new];
        vc.SelectModelBlock = ^(SendTopicModel *topicModel){
            self.topicModel = topicModel;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        if (indexPath.row == 0) {
            SelectLocaltionController *vc = [SelectLocaltionController new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

- (UISwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.xl_width - 65, 8.5, 30, 40)];
        _switchView.onTintColor = RGBACOLOR(11, 128, 214, 1);
        __weak SendDynViewController *cself = self;
        [_switchView addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch  *sender) {
            [cself.tableView reloadData];
        }];
        [_switchView setOn:NO animated:YES];
    }
    return _switchView;
}

- (void)dismissAction
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
