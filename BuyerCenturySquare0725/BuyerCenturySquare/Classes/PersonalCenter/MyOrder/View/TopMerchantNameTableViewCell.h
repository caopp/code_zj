//
//  TopMerchantNameTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderAllListDTO.h"
#import "MyOrderParentTableViewCell.h"

@interface TopMerchantNameTableViewCell : MyOrderParentTableViewCell
/**
 *  选中状态
 */
@property (weak, nonatomic) IBOutlet UIButton *selectMerchantNameBtn;
@property (nonatomic ,strong)OrderInfoListDTO *orderInfo;

- (IBAction)selectMerchantClickBtn:(id)sender;

/**
 *  商家名称
 */
@property (weak, nonatomic) IBOutlet UIButton *merchantNameBtn;
- (IBAction)selectMerchantNameClickBtn:(id)sender;






@end
