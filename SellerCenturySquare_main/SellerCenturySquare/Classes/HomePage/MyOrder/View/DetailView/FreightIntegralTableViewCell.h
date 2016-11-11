//
//  FreightIntegralTableViewCell.h
//  CustomerCenturySquare
//
//  Created by 左键视觉 on 16/6/24.
//  Copyright © 2016年 zuojian. All rights reserved.
// !运费和使用抵扣的积分

#import <UIKit/UIKit.h>
#import "GetOrderDetailDTO.h"

@interface FreightIntegralTableViewCell : UITableViewCell

//!左边的title
@property (weak, nonatomic) IBOutlet UILabel *freightLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
//!积分的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterHightConst;


//!是显示积分：传yes
-(void)configData:(GetOrderDetailDTO *)orderDTO withScore:(BOOL)isScore;


@end
