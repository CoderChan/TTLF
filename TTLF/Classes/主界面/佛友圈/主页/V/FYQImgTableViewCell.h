//
//  FYQImgTableViewCell.h
//  FYQ
//
//  Created by Chan_Sir on 2017/3/3.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"


typedef NS_ENUM(NSInteger,FYQCellClickType) {
    UserClickType = 1,      // 点击用户头像或昵称
    TopicClickType = 2,     // 点击查看话题列表
    PhotoClickType = 3,     // 点击查看大图
    LocationClickType = 4,  // 点击查看地理位置
    ShareClickType = 5,     // 转发分享
    DiscussClickType = 6,   // 点击发表评论
    ZanClickType = 7        // 点赞
};

@protocol FYQTableCellDelegate <NSObject>

- (void)fyqTableCellClickType:(FYQCellClickType)clickType Model:(DynamicModel *)model;

@end

@interface FYQImgTableViewCell : UITableViewCell

/** 动态模型 */
@property (strong,nonatomic) DynamicModel *model;
/** 我的点击回调代理 */
@property (weak,nonatomic) id<FYQTableCellDelegate> delegate;
/** 初始化 */
+ (instancetype)sharedFYQImgTableViewCell:(UITableView *)tableView;

@end
