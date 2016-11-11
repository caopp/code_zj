//
//  CommodityGroupListDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface Commodity : BasicDTO

@property (nonatomic, strong)NSString* goodsNo;
@property (nonatomic, strong)NSString* goodsName;
@property (nonatomic, strong)NSString* merchantNo;
@property (nonatomic, assign)CGFloat   price;
@property (nonatomic, strong)NSString* pictureUrl;
@property (nonatomic, strong)NSString* firstOnsaleTime;
@property (nonatomic, assign)NSInteger batchNumLimit;
@property (nonatomic, strong)NSString* goodsWillNo;
@property (nonatomic, assign)NSInteger readLevel;
@property (nonatomic, strong)NSString* goodsType;
@property (nonatomic, assign)NSInteger dayNum;

//!上架天数多少天内(15天) 当dayNum为0时，列表三角标数值取此值显示
@property (nonatomic, assign)NSInteger withinDays;


@end

@interface CommodityGroup : BasicDTO

@property (nonatomic, assign)NSInteger dayNum;
@property (nonatomic, strong)NSMutableArray* commodityList;

@end

@interface CommodityGroupListDTO : BasicDTO

/**
 *  总条数（类型:int）
 */
@property (nonatomic, assign)NSInteger totalCount;

@property (nonatomic, strong)NSMutableArray* groupList;

@property (nonatomic, strong)NSString* operateStatus;

@property (nonatomic, strong)NSString* closeStartTime;
@property (nonatomic, strong)NSString* closeEndTime;

- (void)addCommoditiesFromDictionary:(NSDictionary*)otherDictionary;

- (BOOL)isLoadedAll;

- (NSInteger)nextPage;

@end
