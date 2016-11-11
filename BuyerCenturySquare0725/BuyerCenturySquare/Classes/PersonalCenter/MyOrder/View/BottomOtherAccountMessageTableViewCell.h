//
//  BottomOtherAccountMessageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface BottomOtherAccountMessageTableViewCell : MyOrderParentTableViewCell
/**
 *  商品所有数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
/**
 *  商品所有价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPriceNumb;
/**
 *  付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;



@end
