//
//  TopOtherOrderTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"
#import "OrderAllListDTO.h"
#import "MyOrderParentTableViewCell.h"
@interface TopOtherOrderTableViewCell : MyOrderParentTableViewCell
/**
 *  商家名称
 */
@property (weak, nonatomic) IBOutlet UIButton *merchantNameBtn;
@property (nonatomic ,strong) OrderInfoListDTO *infoDto;





@end
