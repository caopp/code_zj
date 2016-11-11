//
//  GetImageReferImageHistoryListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetImageReferImageHistoryListDTO : BasicDTO
/**
 *  上传日期
 */
@property(nonatomic,copy)NSString *uploadDate;

/**
 *  状态
 */
@property(nonatomic,copy)NSString *auditStatus;
/**
 *  qty,类型为int
 */
@property(nonatomic,strong)NSNumber *qty;

/**
 * 图片列表
 */
@property(nonatomic,strong)NSMutableArray *imageUrlsList;

@end
