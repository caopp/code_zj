//
//  CartListDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/31/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "DoubleSku.h"
#import "CSPOrderModeUtils.h"


@class CSPCartSectionHeaderView;

@interface CartSku : DoubleSku

@end

@interface CartStepPrice : BasicDTO
//自增ID
@property (nonatomic, assign)NSInteger id;
//阶梯价格
@property (nonatomic, assign)CGFloat price;
//开始数量
@property (nonatomic, assign)NSInteger minNum;
//结束数量
@property (nonatomic, assign)NSInteger maxNum;
//排序
@property (nonatomic, assign)NSInteger sort;

@end

@interface CartGoods : BasicDTO
//商家编码
@property (nonatomic, strong)NSString* merchantNo;
//商家名称
@property (nonatomic, strong)NSString* merchantName;
//商品编码
@property (nonatomic, strong)NSString* goodsNo;
//商品名称
@property (nonatomic, strong)NSString* goodsName;
//商品颜色
@property (nonatomic, strong)NSString* color;
//购买数量
@property (nonatomic, assign)NSInteger quantity;
//商品价格
@property (nonatomic, assign)CGFloat   price;

@property (nonatomic, assign)CGFloat   samplePrice;
//商品图片
@property (nonatomic, strong)NSString* pictureUrl;
//商品状态
@property (nonatomic, strong)NSString* goodsStatus;
//起批数量
@property (nonatomic, assign)NSInteger batchNumLimit;
//商品类型
@property (nonatomic, strong)NSString* cartType;

//sku列表属性
@property (nonatomic, strong)NSMutableArray* skuList;
//阶梯价格表
@property (nonatomic, strong)NSMutableArray* stepPriceList;

@property (nonatomic, assign, readonly)CGFloat totalPrice;

//现货单和期货单的数量
@property (nonatomic ,strong) NSString * totalNumb;


@property (nonatomic, assign)BOOL selected;

- (CartGoodsType)cartGoodsType;
- (BOOL)isValidCartGoods;
- (BOOL)isInvalidCartGoods;
- (BOOL)isCartQuantityLessThanBatchNumLimit;
- (NSInteger)cartQuantity;
- (CGFloat)cartPrice;

- (NSInteger)totalQuantityExceptSku:(BasicSkuDTO*)sku;

@end

@class SaleMerchantCondition;

@interface CartMerchant : BasicDTO
//商家编码
@property (nonatomic, strong)NSString* merchantNo;
//商家名称
@property (nonatomic, strong)NSString* merchantName;

@property (nonatomic, assign, readonly)CGFloat totalPrice;
//商品List列表属性
@property (nonatomic, strong)NSMutableArray* goodsList;

@property (nonatomic, weak)CSPCartSectionHeaderView* headerView;

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)BOOL isSatisfy;
@property (nonatomic, strong)SaleMerchantCondition* condition;

- (BOOL)isThereGoodsSelected;

- (BOOL)isThereGoodsOptional;

- (NSInteger)totalQuantityForSelectedGoods;

- (NSInteger)totalValidGoodsAmount;

- (CGFloat)totalPriceForSelectedGoods;

- (BOOL)isAllGoodsSelected;

@end

@class WholeSaleConditionDTO;

@interface CartListDTO : BasicDTO

@property (nonatomic, strong)NSMutableArray* merchantList;

- (CartGoods*)cartGoodsForIndexPath:(NSIndexPath*)indexPath;

- (NSInteger)totalGoodsAmount;

- (NSInteger)totalValidGoodsAmount;

- (NSInteger)selectedGoodsAmount;

- (BOOL)isAllGoodsSelected;

- (NSInteger)goodsAmountForSection:(NSInteger)section;

- (CGFloat)totalPriceForSelectedGoods;

- (NSInteger)totalQuantityForSelectedGoods;

- (NSArray*)selectedCartStatisticalListToCheckWholesaleCondition;

- (void)updateMerchantsInfoByWholeSaleCondition:(WholeSaleConditionDTO*)wholeSaleCondition;

- (NSIndexSet*)changedSectionsIndexSet;

- (NSArray*)selectedGoodsDictionaryList;

@end
