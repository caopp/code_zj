//
//  CommodityClassification.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CommodityClassification.h"
#import "CommodityClassificationDTO.h"

@interface CommodityClassification ()
//一级
@property(nonatomic, strong)NSMutableArray* primaryList;
// parentID:secondCategoryList
//二级
@property(nonatomic, strong)NSMutableDictionary* secondaryDictionary;
@property(nonatomic, strong)NSMutableDictionary* thirdlyDictionary;

@end

@implementation CommodityClassification

- (id)initWithDictionaries:(NSArray *)dictionaries {
    @try {
        self = [super init];
        if (self) {
            NSMutableArray* categoryList = [NSMutableArray array];
            for (NSDictionary* dict in dictionaries) {
                CommodityClassificationDTO* dto = [[CommodityClassificationDTO alloc]init];
                [dto setDictFrom:dict];
                [categoryList addObject:dto];
            }
            
            for (CommodityClassificationDTO* dto in categoryList) {
                if (dto.level.intValue == 1) {
                    [self.primaryList addObject:dto];
                    
                } else if (dto.level.intValue == 2) {
                    NSMutableArray* secondaryList = [self.secondaryDictionary objectForKey:dto.parentId];
                    if (secondaryList == nil) {
                        secondaryList = [NSMutableArray array];
                        CommodityClassificationDTO* dtoLevel = [[CommodityClassificationDTO alloc]init];
//                        dtoLevel = dto;
                        dtoLevel.parentId = dto.parentId;
                        dtoLevel.level = dto.level;
                        dtoLevel.structureName = dto.structureName;
                        
                        NSString *structureNo = [[dto.structureNo componentsSeparatedByString:@"-"] firstObject];
                        
                        dtoLevel.structureNo = structureNo;
                        dtoLevel.categoryName = @"全部";
                        
                        [secondaryList addObject:dtoLevel];
                        [self.secondaryDictionary setObject:secondaryList forKey:dto.parentId];
                    }
                    
                    [secondaryList addObject:dto];
                } else {
                    NSMutableArray* thirdlyList = [self.thirdlyDictionary objectForKey:dto.parentId];
                    if (thirdlyList == nil) {
                        thirdlyList = [NSMutableArray array];
                        [self.thirdlyDictionary setObject:thirdlyList forKey:dto.parentId];
                    }
                    
                    [thirdlyList addObject:dto];
                }
            }
        }
        return self;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   
}

- (NSArray*)primaryCategory {
    return [self.primaryList copy];
}

- (NSDictionary*)secondaryCategory {
    return [self.secondaryDictionary copy];
}

- (NSDictionary*)thirdlyCategory {
    return [self.thirdlyDictionary copy];
}

- (NSMutableArray*)primaryList {
    if (!_primaryList) {
        _primaryList = [NSMutableArray array];
    }

    return _primaryList;
}

- (NSMutableDictionary*)secondaryDictionary {
    if (!_secondaryDictionary) {
        _secondaryDictionary = [NSMutableDictionary dictionary];
    }

    return _secondaryDictionary;
}

- (NSMutableDictionary*)thirdlyDictionary {
    if (!_thirdlyDictionary) {
        _thirdlyDictionary = [NSMutableDictionary dictionary];
    }

    return _thirdlyDictionary;
}

- (NSArray*)getPrimarycategory {
    return [self.primaryList copy];
}

- (NSArray*)getSecondaryCategoryWithParentId:(NSNumber*)parentId {
    return [[self.secondaryDictionary objectForKey:parentId] copy];
}

- (NSArray*)getThirdlyCategoryWithParentId:(NSNumber*)parentId {
    return [[self.thirdlyDictionary objectForKey:parentId] copy];
}


@end
