//
//  ReplenishmentByMerchantDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "SingleSku.h"

@class CSPReplenishmentSectionHeaderView;

@interface ReplenishmentSku : SingleSku

@end



@interface ReplenishmentStepPrice : BasicDTO

@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, assign)NSInteger minNum;
@property (nonatomic, assign)NSInteger maxNum;
@property (nonatomic, assign)NSInteger sort;

@end



@interface ReplenishmentGoods : BasicDTO

@property (nonatomic, strong)NSString* merchantNo;
@property (nonatomic, strong)NSString* merchantName;
@property (nonatomic, strong)NSString* goodsNo;
@property (nonatomic, strong)NSString* goodsName;
@property (nonatomic, strong)NSString* color;
@property (nonatomic, strong)NSString* pictureUrl;
@property (nonatomic, assign)NSInteger batchNumLimit;
@property (nonatomic, assign)CGFloat   batchPrice;
@property (nonatomic, strong)NSMutableArray* skuList;
@property (nonatomic, strong)NSNumber *goodsWillNo;

@property (nonatomic, strong)NSMutableArray* stepPriceList;

@property (nonatomic, assign)BOOL selected;

- (NSInteger)totalQuantity;

- (NSMutableArray*)skuDictionaryList;

- (NSInteger)totalQuantityExceptSku:(ReplenishmentSku*)skuInfo;

- (CGFloat)stepPriceForCurrentQuantity;

- (NSMutableArray*)doubleSkuList;

- (NSMutableArray*)stepPriceDTOList;

@end



@interface ReplenishmentMerchant : BasicDTO

@property (nonatomic, strong)NSString* merchantNo;
@property (nonatomic, strong)NSString* merchantName;
@property (nonatomic, strong)NSMutableArray* goodsList;

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, weak)CSPReplenishmentSectionHeaderView* headerView;

- (void)selectAllGoodsOfCurrentMerchant:(BOOL)select;

- (BOOL)isAllGoodsSelected;

@end




@interface ReplenishmentByMerchantDTO : BasicDTO

@property(nonatomic, strong)NSMutableArray* merchantList;

- (NSArray*)goodsListForAddingCart;

@end
