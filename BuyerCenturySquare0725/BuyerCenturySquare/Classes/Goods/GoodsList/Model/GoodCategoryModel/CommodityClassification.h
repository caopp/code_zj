//
//  CommodityClassification.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  商品分类总集

#import <Foundation/Foundation.h>

@interface CommodityClassification : NSObject

@property(nonatomic, strong, readonly)NSArray* primaryCategory;
@property(nonatomic, strong, readonly)NSDictionary* secondaryCategory;
@property(nonatomic, strong, readonly)NSDictionary* thirdlyCategory;

- (id)initWithDictionaries:(NSArray*)dictionaries;

- (NSArray*)getPrimarycategory;
- (NSArray*)getSecondaryCategoryWithParentId:(NSNumber*)parentId;
- (NSArray*)getThirdlyCategoryWithParentId:(NSNumber*)parentId;

@end
