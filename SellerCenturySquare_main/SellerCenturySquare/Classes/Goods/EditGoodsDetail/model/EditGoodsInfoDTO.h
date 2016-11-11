//
//  EditGoodsInfoDTO.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "EditSkuDTO.h"

@interface EditGoodsInfoDTO : BasicDTO

/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  商品详情
 */
@property(nonatomic,copy)NSString *details;

/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString *color;

/**
 *  商品类别名称
 */
@property(nonatomic,copy)NSString *categoryName;


/**
 *  品牌名称
 */
@property(nonatomic,copy)NSString *brandName;

/**
 *  商品价格(Double 类型)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  上架时间
 */
@property(nonatomic,copy)NSString *onSaleTime;
/**
 *  下架时间
 */
@property(nonatomic,copy)NSString *offSaleTime;

/**
 *  是否有样板价(1有、2无)
 */
@property(nonatomic,copy)NSString *sampleFlag;

/**
 *  样板价(Double 类型)
 */
@property(nonatomic,strong)NSNumber *samplePrice;

/**
 *  商品类型 0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;

/**
 *  起批数量
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;



/**
 *  商品列表图
 */
@property(nonatomic,copy)NSString *defaultPicUrl;

/**
 *  商品状态  1:新发布  2:在售  3:下架
 */
@property(nonatomic,strong)NSNumber *goodsStatus;

/**
 *  混批条件描述
 */
@property(nonatomic,copy)NSString *batchMsg;


/**
 *  skuList列表(SkuDTO)
 */
@property(nonatomic,strong)NSMutableArray *skuDTOList;





@end
