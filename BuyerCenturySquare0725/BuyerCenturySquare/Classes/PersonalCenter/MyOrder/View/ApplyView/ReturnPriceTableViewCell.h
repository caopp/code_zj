//
//  ReturnPriceTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplyDTO.h"

@interface ReturnPriceTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextView *priceTextView;


-(void)setPriceTextViewContent:(RefundApplyDTO *)applyDTO withMostAlert:(NSString *)mostAlertStr;


@end
