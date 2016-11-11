//
//  MerchantCloseLogDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MerchantCloseLogDTO : BasicDTO
/**
 *  记录ID
 */
@property(nonatomic,strong)NSNumber *Id;
/**
 *  歇业开始时间
 */
@property(nonatomic,copy)NSString *closeStartTime;
/**
 *  歇业结束时间
 */
@property(nonatomic,copy)NSString *closeEndTime;

@end
