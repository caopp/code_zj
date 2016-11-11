//
//  TitleZoneGoodsTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/11/24.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleZoneGoodsTableViewCell : UITableViewCell

@property (nonatomic ,strong)UILabel *titleLabel;

/**
 *  没有订单的时候提示内容
 *
 *  @param channelType 订单：0:大B 1：小B 订单列表：2大B
 */
- (void)titleZoneGoodsChannelType:(NSString *)channelType;



@end
