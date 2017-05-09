//
//  ImageTableViewCell.h
//  TTLF
//
//  Created by Chan_Sir on 2017/5/9.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

/***** 只有一张单图的cell *****/
@interface ImageTableViewCell : UITableViewCell

@property (copy,nonatomic) NSString *image_url;

+ (instancetype)sharedImageCell:(UITableView *)tableView;

@end
