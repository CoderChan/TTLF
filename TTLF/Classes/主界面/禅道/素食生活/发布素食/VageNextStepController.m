//
//  VageNextStepController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "VageNextStepController.h"
#import "NormalTableViewCell.h"
#import "PYPhotoBrowser.h"
#import <LCActionSheet.h>
#import "TZImagePickerController.h"
#import <Masonry.h>
#import "VageDetialViewController.h"


#define FoodPlace @"如\r豆腐、青葱、淀粉、少量生抽、油、盐、鸡精、水"
#define StepPlace @"如\r1、豆腐切好块状，热锅、放油。\r2、将豆腐放入热锅内煎到6分熟。\r3、放盐和鸡精，翻均匀。\r4、重点来了，把准备好的淀粉和水、生抽搅拌均匀，导入锅内。\r5、3-5秒钟后，把切好的青葱放入锅内。\r几秒钟后一盘热腾腾的客家青葱豆腐色香味俱全，跃然餐桌。"

@interface VageNextStepController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TZImagePickerControllerDelegate,PYPhotosViewDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源、步骤 */
@property (copy,nonatomic) NSArray *array;
/** 食材输入框 */
@property (strong,nonatomic) UITextView *foodTextView;
/** 烹饪步骤输入框 */
@property (strong,nonatomic) UITextView *stepTextView;

/** 九宫格 */
@property (strong,nonatomic) PYPhotosView *publishPhotosView;
/** 提示文字 */
@property (strong,nonatomic) UILabel *label;

@end

@implementation VageNextStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传素食菜谱";
    [self setupSubViews];
}
#pragma mark - 添加表格
- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:GreenColor];
    
    // 添加食材、烹饪步骤描述、上图
    self.array = @[@[@"需要的食材"],@[@"烹饪步骤"],@[@"素食辅助图"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}

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
        // 食材
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.foodTextView];
        return cell;
    }else if (indexPath.section == 1){
        // 烹饪步骤
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.stepTextView];
        return cell;
    }else {
        // 素食辅助图
        NormalTableViewCell *cell = [NormalTableViewCell sharedNormalCell:tableView];
        [cell.iconView removeFromSuperview];
        [cell.titleLabel removeFromSuperview];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.publishPhotosView];
        [cell.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
            make.height.equalTo(@20);
        }];
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
        return 60 * CKproportion;
    }else if (indexPath.section == 1){
        return 110 * CKproportion;
    }else{
        return PYPhotoMargin * 4 + PYPhotoHeight * 3 + 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = self.array[section];
    
    UIView *headView = [UIView new];
    headView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    headView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, self.view.width - 30, 30)];
    label.backgroundColor = headView.backgroundColor;
    label.text = titleArray.firstObject;
    label.textColor = GreenColor;
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:20];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [label addGestureRecognizer:tap];
    [headView addSubview:label];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

#pragma mark - 选择图片的代理
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            // 之前和现在的
            NSMutableArray *photosArray = [NSMutableArray array];
            for (UIImage *image in images) {
                [photosArray addObject:image];
            }
            for (UIImage *image in photos) {
                [photosArray addObject:image];
            }
            [self.publishPhotosView reloadDataWithImages:photosArray];
        }
    };
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    KGLog(@"进入预览图片");
}

#pragma mark - 其他方法
- (void)finishAction
{
    [self.view endEditing:YES];
    
    if (self.publishPhotosView.images.count <= 3) {
        [MBProgressHUD showError:@"请上传3-9张图"];
        return;
    }
    
#ifdef DEBUG // 处于开发阶段
    
#else // 处于发布阶段
    if ([self.foodTextView.text isEqualToString:FoodPlace]) {
        [MBProgressHUD showError:@"请输入食材"];
        return;
    }
    if ([self.stepTextView.text isEqualToString:StepPlace]) {
        [MBProgressHUD showError:@"请描述步骤"];
        return;
    }
#endif
    
    NSMutableArray *vageImages = [NSMutableArray array];
    [vageImages addObject:self.coverImage];
    for (int i = 0; i < self.publishPhotosView.images.count; i++) {
        UIImage *image = self.publishPhotosView.images[i];
        [vageImages addObject:image];
    }
    [MBProgressHUD showMessage:@"上传中···"];
    [[TTLFManager sharedManager].networkManager shareVageWithVageName:self.vageName Story:self.vageStory Images:vageImages VageFoods:self.foodTextView.text Steps:self.stepTextView.text Progress:^(NSProgress *progress) {
        NSLog(@"progress = %f",progress.fractionCompleted);
    } Success:^(NSDictionary *vegeDict) {
        [MBProgressHUD hideHUD];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [YLNotificationCenter postNotificationName:CreateNewVegeNoti object:nil userInfo:vegeDict];
        }];
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendAlertAction:errorMsg];
    }];
    
    
}
#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.foodTextView) {
        if ([self.foodTextView.text isEqualToString:FoodPlace]) {
            self.foodTextView.text = @"";
        }else{
            textView.font = [UIFont systemFontOfSize:16];
            textView.textColor = [UIColor blackColor];
        }
    } else {
        if ([self.stepTextView.text isEqualToString:StepPlace]) {
            self.stepTextView.text = @"";
        }else{
            textView.font = [UIFont systemFontOfSize:16];
            textView.textColor = [UIColor blackColor];
        }
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.foodTextView) {
        if ([self.foodTextView.text isEqualToString:@""]) {
            self.foodTextView.text = FoodPlace;
            textView.font = [UIFont systemFontOfSize:13];
            textView.textColor = [UIColor lightGrayColor];
        }else{
            textView.font = [UIFont systemFontOfSize:16];
            textView.textColor = [UIColor blackColor];
        }
    }else{
        if ([self.stepTextView.text isEqualToString:@""]) {
            self.stepTextView.text = StepPlace;
            textView.font = [UIFont systemFontOfSize:13];
            textView.textColor = [UIColor lightGrayColor];
        }else{
            textView.font = [UIFont systemFontOfSize:16];
            textView.textColor = [UIColor blackColor];
        }
    }
}


#pragma mark - 懒加载
- (UITextView *)foodTextView
{
    if (!_foodTextView) {
        _foodTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, self.view.width - 30, 60 * CKproportion - 10)];
        _foodTextView.text = FoodPlace;
        _foodTextView.textColor = [UIColor lightGrayColor];
        _foodTextView.delegate = self;
        _foodTextView.font = [UIFont systemFontOfSize:13];
    }
    return _foodTextView;
}
- (UITextView *)stepTextView
{
    if (!_stepTextView) {
        _stepTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, 3, self.view.width - 30, 110 * CKproportion - 6)];
        _stepTextView.text = StepPlace;
        _stepTextView.textColor = [UIColor lightGrayColor];
        _stepTextView.delegate = self;
        _stepTextView.font = [UIFont systemFontOfSize:13];
    }
    return _stepTextView;
}
- (PYPhotosView *)publishPhotosView
{
    if (!_publishPhotosView) {
        _publishPhotosView = [PYPhotosView photosView];
        _publishPhotosView.x = (SCREEN_WIDTH - PYPhotoWidth * PYPhotosMaxCol - PYPhotoMargin * (PYPhotosMaxCol + 1))/2;
        _publishPhotosView.y = PYPhotoMargin;
        _publishPhotosView.images = @[].mutableCopy;
        _publishPhotosView.delegate = self;
    }
    return _publishPhotosView;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"图片至少3张，最多9张，建议9张拼成九宫格";
        _label.textColor = GreenColor;
        _label.textAlignment = NSTextAlignmentRight;
        _label.font = [UIFont systemFontOfSize:10];
    }
    return _label;
}

@end
