//
//  ImageDownloadCallbackModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ImageDownloadCallbackModel : BasicDTO

/**
 *  商品编号
 */
@property(nonatomic,copy)NSString* goodsNo;
/**
 *  0窗口图，1客观图
 */
@property(nonatomic,copy)NSString* picType;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end
