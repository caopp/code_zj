//
//  GoodsCollectionByTimeDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CollectionGoods : BasicDTO

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString* goodsNo;
@property (nonatomic, strong) NSString* goodsName;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, strong) NSString* pictureUrl;
@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) NSInteger batchNumLimit;
@property (nonatomic, strong) NSString* merchantNo;
@property (nonatomic, strong) NSString* merchantName;

@property (nonatomic, assign) BOOL selected;

@end

@interface GoodsCollectionByTimeDTO : BasicDTO

/**
 * 3.23	小B商品收藏列表接口(按时间排序) 里面是FavoriteDTO对象
 */
@property(nonatomic,strong)NSMutableArray *goodsList;

- (NSMutableArray*)selectedGoodsList;

@end
