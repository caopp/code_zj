//
//  MerchantLeftSlideCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantLeftSlideCell : UITableViewCell

//!商家分类名称
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

//!左边的
@property (weak, nonatomic) IBOutlet UILabel *leftFilterLabel;

//!右边的
@property (weak, nonatomic) IBOutlet UILabel *rightFilterLabel;



@end
