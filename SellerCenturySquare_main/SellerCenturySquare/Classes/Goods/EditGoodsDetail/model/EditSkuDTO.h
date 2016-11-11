//
//  EditSkuDTO.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface EditSkuDTO : BasicDTO


/**
 *sku编码
 */
@property(nonatomic,copy)NSString * skuNo;


/**
 *sku编码
 */
@property(nonatomic,assign)NSInteger Id;


/**
 *sku名称
 */
@property(nonatomic,copy)NSString *  skuName;

/**
 *库存
 */
@property(nonatomic,assign)NSInteger skuStock;

/**
 *是否有货 1:有货0:无货
 */
@property(nonatomic,copy)NSString *  showStockFlag;

/**
 *排序
 */
@property(nonatomic,copy)NSString *  sort;


@end
