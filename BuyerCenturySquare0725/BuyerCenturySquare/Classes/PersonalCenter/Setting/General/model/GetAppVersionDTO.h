//
//  GetAppVersionDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetAppVersionDTO : BasicDTO

/**
 *  下载地址
 */
@property(nonatomic,copy)NSString *downUrl;
/**
 *  版本号
 */
@property(nonatomic,copy)NSString *version;

@end
