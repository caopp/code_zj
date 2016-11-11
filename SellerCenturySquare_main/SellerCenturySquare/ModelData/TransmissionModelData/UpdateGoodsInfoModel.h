//
//  UpdateGoodsInfoModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsInfoSkuDTOModel : BasicDTO

/**
 *  sku编码
 */
@property(nonatomic,copy)NSString* skuNo;
/**
 *  是否有货(1:有货0:无货)
 */
@property(nonatomic,copy)NSString* showStockFlag;

- (NSMutableDictionary* )getDictFrom:(GoodsInfoSkuDTOModel *)goodsInfoSkuDTOModel;
@end

@interface GoodsInfoStepDTOModel : BasicDTO

/**
 *  阶梯价格ID(类型:Int)
 */
@property(nonatomic,strong)NSNumber *Id;

/**
 *  价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  最小数量(类型:Int)
 */
@property(nonatomic,strong)NSNumber *minNum;

/**
 *  最大数量(类型:Int)
 */
@property(nonatomic,strong)NSNumber *maxNum;

- (NSMutableDictionary* )getDictFrom:(GoodsInfoStepDTOModel *)goodsInfoSkuDTOModel;

@end


@interface UpdateGoodsInfoModel : BasicDTO

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;
/**
 *  商品状态
 */
@property(nonatomic,copy)NSString* goodsStatus;

/**
 *  商品名称
 */
@property(nonatomic,copy)NSString* goodsName;

/**
 *  商品价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  是否有样板价(1有、2无)
 */
@property(nonatomic,copy)NSString *sampleFlag;

/**
 *  样板价(类型:double)
 */
@property(nonatomic,strong)NSNumber *samplePrice;


/**
 *  Sku数组(UpdateGoodsInfoSkuDTOModel)
 */
@property(nonatomic,strong)NSMutableArray *updateGoodsInfoSkuDTOModelList;
/**
 *  阶梯价格数组(UpdateGoodsInfoStepDTOModel)
 */
@property(nonatomic,strong)NSMutableArray *updateGoodsInfoStepDTOModelList;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end
