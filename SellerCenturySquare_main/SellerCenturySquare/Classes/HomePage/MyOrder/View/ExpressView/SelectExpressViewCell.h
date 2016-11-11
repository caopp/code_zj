//
//  SelectExpressViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
// !选择快递公司

#import <UIKit/UIKit.h>

@interface SelectExpressViewCell : UITableViewCell

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!快递公司名称
@property (weak, nonatomic) IBOutlet UILabel *expressNameLabel;



@end
