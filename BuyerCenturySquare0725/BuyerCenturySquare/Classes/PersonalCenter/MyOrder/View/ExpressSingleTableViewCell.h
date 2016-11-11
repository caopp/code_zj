//
//  ExpressSingleTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDeliveryDTO.h"

@interface ExpressSingleTableViewCell : UITableViewCell
@property (nonatomic ,strong) OrderDeliveryDTO *orderDeliverDto;

/**
 *  发货次数
 */
@property (nonatomic ,assign) NSInteger number;

@end
