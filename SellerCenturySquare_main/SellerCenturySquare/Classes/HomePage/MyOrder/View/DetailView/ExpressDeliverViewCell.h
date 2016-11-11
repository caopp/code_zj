//
//  ExpressDeliverViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDetailDTO.h"

@interface ExpressDeliverViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;


@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeLogLabel;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!num:数组中的第几个值
-(void)configData:(OrderDeliveryDTO *)deliverDTO withNum:(NSInteger)num;



@end
