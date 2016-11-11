//
//  EditGoodsDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "GetGoodsInfoListDTO.h"

@interface EditGoodsDTO : BasicDTO


/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商品价格(double 类型)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  图片路径
 */
@property(nonatomic,copy)NSString *imgUrl;
/**
 *  货号
 */
@property(nonatomic,copy)NSString *goodsWillNo;

/**
 *  颜色
 */
@property(nonatomic,copy)NSString *color;

/**
 * 商品类型 0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;

/**
* 商品状态：0编辑中，1新发布未上架，2已上架，3已下架
*/
@property(nonatomic,copy)NSString * goodsStatus;


/**
 * 第一次上架时间
 */
@property(nonatomic,copy)NSString *firstOnsaleTime;


/**
 * 会员价格
 */
@property(nonatomic,strong)NSNumber *price1;
@property(nonatomic,strong)NSNumber *price2;
@property(nonatomic,strong)NSNumber *price3;
@property(nonatomic,strong)NSNumber *price4;
@property(nonatomic,strong)NSNumber *price5;
@property(nonatomic,strong)NSNumber *price6;

/**
 * 商品销售渠道
 */
@property(nonatomic,copy)NSString * channelList;

//!零售价格
@property(nonatomic,strong)NSNumber *retailPrice;



@end


