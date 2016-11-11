//
//  AccordOrderDetailTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDeliveryDTO.h"
#import "OrderDetailDTO.h"
@interface AccordOrderDetailTableViewCell : UITableViewCell
{
    
    int timeInterval;//!倒计时间
    
    
}

@property (nonatomic ,strong) OrderDeliveryDTO *deliverDto;
@property (nonatomic ,strong) OrderDetailDTO *detailDto;
@property (nonatomic ,strong) OrderDetailDTO *detailFooterDto;
@property (nonatomic ,strong) NSString *changeTop;
@property (nonatomic ,assign) NSInteger number;
@property (weak, nonatomic) IBOutlet UILabel *cancelOrderTimeLab;

/**
 *  header 顶部， footer底部
 */
@property (nonatomic, strong) NSString *orderType;




@end
