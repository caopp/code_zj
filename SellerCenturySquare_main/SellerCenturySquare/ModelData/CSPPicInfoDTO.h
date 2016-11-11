//
//  CSPPicInfoDTO.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CSPPicInfoDTO : BasicDTO

/**
 *  商品编号
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  下载类型(3所有，0窗口图，1客观图)
 */
@property(nonatomic,copy)NSString *downLoadType;

@end
