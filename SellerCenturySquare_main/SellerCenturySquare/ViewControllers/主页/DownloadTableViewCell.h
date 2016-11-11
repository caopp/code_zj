//
//  DownloadTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

//更新数量
- (void)updateNum:(NSString*)num WithTitle:(NSString *)title;
@end
