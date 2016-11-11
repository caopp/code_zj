//
//  GetMerchantCloseLogDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetMerchantCloseLogDTO : BasicDTO
/**
 *  是否有设定歇业权限
 */
@property(nonatomic,copy)NSString *isSetClose;
/**
 *  歇业记录明细列表(可以设定歇业则不返回List数据)
 */
@property(nonatomic,strong)NSMutableArray *MerchantCloseLogDTOList;

@end
