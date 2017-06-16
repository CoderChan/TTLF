//
//  BookTableHeadView.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableHeadView : UIView

@property (strong,nonatomic) BookInfoModel *model;

/** 书本的封面 */
@property (strong,nonatomic) UIImageView *bookCoverImgView;
/** 书本的名称 */
@property (strong,nonatomic) UILabel *bookNameLabel;
/** 作者 */
@property (strong,nonatomic) UILabel *bookWriterLabel;
/** 类型 */
@property (strong,nonatomic) UILabel *bookTypeLabel;

@end
