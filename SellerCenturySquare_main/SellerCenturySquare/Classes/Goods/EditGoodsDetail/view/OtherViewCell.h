//
//  OtherViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *leftInfoLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterLabelHight;

@end
