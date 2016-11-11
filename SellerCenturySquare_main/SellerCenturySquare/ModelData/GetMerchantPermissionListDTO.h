//
//  GetMerchantPermissionListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.23	商家等级权限说明接口
#import "BasicDTO.h"

@interface GetMerchantPermissionListDTO : BasicDTO

/**
 *  商家等级权限说明列表信息(MerchantPermissionDTO)
 */
@property(nonatomic,strong)NSMutableArray *merchantPermissionDTOList;
@end
