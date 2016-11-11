//
//  BrandSearchGoodsDto.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface BrandSearchGoodsDTO : BasicDTO

/**
 *  总数量
 */
@property (nonatomic ,strong) NSNumber *totalCount;

/**
 *  品牌列表
 */
@property (nonatomic ,strong) NSMutableArray *listGoodsArr;;

@end

@interface GoodsListDTO : BasicDTO
/**
 *  品牌编码
 */
@property (nonatomic ,copy) NSString *brandNo;
/**
 *  中文名称
 */
@property (nonatomic ,copy) NSString *cnName;

/**
 *  英文名
 */
@property (nonatomic ,copy) NSString *enName;

@end