//
//  CommodityGroupListDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !

#import "BasicDTO.h"

// !单独的一个商品
@interface Commodity : BasicDTO

@property (nonatomic, strong)NSString* goodsType;
@property (nonatomic, strong)NSString* sendTime;
@property (nonatomic, strong)NSString* pictureUrl;
@property (nonatomic, strong)NSString* authFlag;
@property (nonatomic, strong)NSString* firstOnsaleTime;
@property (nonatomic, assign)CGFloat   price;
@property (nonatomic, assign)NSInteger batchNumLimit;
@property (nonatomic, assign)NSInteger remark;
@property (nonatomic, strong)NSString* goodsName;
@property (nonatomic, strong)NSString* goodsNo;
@property (nonatomic, assign)NSInteger readLevel;
@property (nonatomic, assign)NSInteger dayNum;

//!上架天数多少天内(15天)，当dayNum为0时，列表三角标数值取此值显示
@property (nonatomic, assign)NSInteger withinDays;

//!0未推荐  1推荐
@property (nonatomic, assign)NSInteger recommendFlag;



// !是否有权限查看
- (BOOL)isReadable;


@end


// !包含了天数相同的商品
@interface CommodityGroup : BasicDTO

@property (nonatomic, assign)NSInteger dayNum;
@property (nonatomic, strong)NSMutableArray* commodityList;

@end

// !包含了分好租的所有商品
@interface CommodityGroupListDTO : BasicDTO

/**
 *  总条数（类型:int）
 */
@property (nonatomic, assign)int totalCount;

@property (nonatomic, strong)NSMutableArray* groupList;

//!isByDaySave：是否按上新时间段存放
- (id)initWithDictionary:(NSDictionary *)dictionary withByDaySave:(BOOL)isByDaySave;

- (void)addCommoditiesFromDictionary:(NSDictionary*)otherDictionary withByDaySave:(BOOL)isByDaySave;

// !获得总的商品数量
- (NSInteger)loadedItemsAmount;

- (BOOL)isLoadedAll;

- (NSInteger)nextPage;


@end
