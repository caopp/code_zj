//
//  ChannelDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ChannelDTO : BasicDTO

/**
 * 频道ID
 */

@property(nonatomic,strong)NSNumber * ids;

/**
 *频道名称
 */
@property(nonatomic,copy)NSString * channelName;

/*
 频道顶部图片
 */
@property(nonatomic,copy)NSString * channelImg;


@end
