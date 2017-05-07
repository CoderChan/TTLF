//
//  ShareVageViewController.m
//  TTLF
//
//  Created by Chan_Sir on 2017/4/23.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ShareVageViewController.h"
#import "VageNextStepController.h"
#import <Masonry.h>
#import <LCActionSheet.h>


#define TextPlace @"添加这道素食背后的故事，更具韵味。"
@interface ShareVageViewController ()<UITextViewDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 封面图 */
@property (strong,nonatomic) UIImageView *coverImgView;
/** 菜谱名 */
@property (strong,nonatomic) UITextField *nameField;
/** 菜谱背后的故事 */
@property (strong,nonatomic) UITextView *storyTextView;
/** 添加封面的文字 */
@property (strong,nonatomic) UILabel *addTipLabel;

@end

@implementation ShareVageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享素食";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:MainColor];
    
    // 精品提示
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.width, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, topView.width - 20 - 40, 20)];
    tipLabel.text = @"如何使自己的素食菜谱成为精品推荐？";
    tipLabel.textColor = MainColor;
    tipLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [topView addSubview:tipLabel];
    
    UIImageView *jiantouImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_jiantou"]];
    jiantouImgV.frame = CGRectMake(topView.width - 33, 15, 20, 20);
    [topView addSubview:jiantouImgV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        NSURL *url = [NSURL URLWithString:@"http://m.douguo.com/?/group/post/282384.html"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [topView addGestureRecognizer:tap];
    
    UIImageView *xian1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.width, 2)];
    xian1.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:xian1];
    
    // 菜谱名称
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(xian1.frame), self.view.width - 30, 60)];
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.font = [UIFont boldSystemFontOfSize:24];
    self.nameField.placeholder = @"添加素食菜名";
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24],NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1)}];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.nameField];
    
    // 线
    UIImageView *xian2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian2.frame = CGRectMake(15, CGRectGetMaxY(self.nameField.frame), self.view.width - 15, 2);
    [self.view addSubview:xian2];
    
     // 素食描述
    self.storyTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(xian2.frame), self.view.width - 30, 120*CKproportion)];
    self.storyTextView.backgroundColor = [UIColor whiteColor];
    self.storyTextView.text = TextPlace;
    self.storyTextView.textColor = RGBACOLOR(158, 158, 158, 1);
    self.storyTextView.font = [UIFont systemFontOfSize:13];
    self.storyTextView.delegate = self;
    [self.view addSubview:self.storyTextView];
    
    // 上传封面图
    self.coverImgView = [[UIImageView alloc]init];
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.coverImgView setContentScaleFactor:[UIScreen mainScreen].scale];
    self.coverImgView.layer.masksToBounds = YES;
    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.coverImgView.backgroundColor = RGBACOLOR(250, 246, 232, 1);
    self.coverImgView.userInteractionEnabled = YES;
    [self.view addSubview:self.coverImgView];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(230*CKproportion));
    }];
    __weak __block ShareVageViewController *copySelf = self;
    UITapGestureRecognizer *addImgTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:copySelf cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet show];
    }];
    [self.coverImgView addGestureRecognizer:addImgTap];
    
    // 添加封面
    self.addTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 230 * CKproportion/2 - 15,self.view.width - 100, 30)];
    self.addTipLabel.text = @"添加封面";
    self.addTipLabel.font = [UIFont systemFontOfSize:14];
    self.addTipLabel.textAlignment = NSTextAlignmentCenter;
    self.addTipLabel.textColor = MainColor;
    [self.coverImgView addSubview:self.addTipLabel];
    
#ifdef DEBUG // 处于开发阶段
    self.nameField.text = @"小葱拌豆腐";
    self.storyTextView.text = @"小葱拌豆腐是一道经典的汉族名菜。此菜色泽素雅淡洁，清香飘逸，鲜嫩爽口。豆腐蛋白质中含有人体自己所不能合成的8种必需氨基酸，其人体消化率可达92%-96%，是一种既富于营养又易于消化的食品。此菜色泽素雅淡洁，清香滑软，鲜嫩爽口。\r小葱拌豆腐——一清(青)二白，清是引申过来的。本意是说葱是青色的，豆腐是白色的。比喻清清楚楚，明明白白；也指非常清白。也作“一青二白”。";
    self.coverImgView.image = [UIImage imageNamed:@"vage_place"];
#else // 处于发布阶段

#endif
}


#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.storyTextView.text isEqualToString:TextPlace]) {
        self.storyTextView.text = @"";
    }else{
        textView.font = [UIFont systemFontOfSize:16];
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.storyTextView.text isEqualToString:@""]) {
        self.storyTextView.text = TextPlace;
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor lightGrayColor];
    }else{
        textView.font = [UIFont systemFontOfSize:16];
        textView.textColor = [UIColor blackColor];
    }
}

#pragma mark - 其他方法
- (void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)nextStepAction
{
    VageNextStepController *nextStep = [VageNextStepController new];
    nextStep.coverImage = self.coverImgView.image;
    nextStep.vageName = self.nameField.text;
    nextStep.vageStory = self.storyTextView.text;
    [self.navigationController pushViewController:nextStep animated:YES];
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
        self.addTipLabel.hidden = YES;
        [self.coverImgView setImage:orgImage];
    }else{
        [MBProgressHUD showError:@"暂不支持此类型的图片"];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
