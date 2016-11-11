//
//  GetGoodsShareLinkDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetGoodsShareLinkDTO : BasicDTO

/**
 *  分享标题
 */
@property(nonatomic,copy)NSString *title;
/**
 *  分享链接
 */
@property(nonatomic,copy)NSString *shareUrl;
/**
 *  图片链接
 */
@property(nonatomic,copy)NSString *imgUrl;

/**
 *  图片
 */

@property (nonatomic,strong)UIImage *shareImage;

@end
