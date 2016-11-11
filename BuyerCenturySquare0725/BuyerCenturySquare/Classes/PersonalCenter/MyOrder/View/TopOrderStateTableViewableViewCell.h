//
//  TopOrderStateTableViewableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface TopOrderStateTableViewableViewCell : MyOrderParentTableViewCell
/**
 *  采购单状体《现货单，期货单》
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNameLab;
/**
 *  商品状态 待发，未发，等等。
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsStateLab;

@end
