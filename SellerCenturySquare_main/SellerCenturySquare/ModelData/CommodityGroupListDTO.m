//
//  CommodityGroupListDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CommodityGroupListDTO.h"

const NSInteger customPageSize = 20;

#pragma mark -
#pragma mark Commodity

@implementation Commodity

- (void)setDictFrom:(NSDictionary *)dictInfo {
    if (!dictInfo) {
        return;
    }
    
    @try {
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
            
            self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
            
            self.goodsName = [dictInfo objectForKey:@"goodsName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            
            if ([[dictInfo objectForKey:@"price"] isKindOfClass:[NSString class]]) {
                self.price = 0.0;
            } else {
                NSNumber* price = [dictInfo objectForKey:@"price"];
                self.price = price.floatValue;
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
            
            self.pictureUrl = [dictInfo objectForKey:@"imgUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"firstOnsaleTime"]]) {
            
            self.firstOnsaleTime = [dictInfo objectForKey:@"firstOnsaleTime"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
            
            if ([[dictInfo objectForKey:@"batchNumLimit"] isKindOfClass:[NSString class]]) {
                self.batchNumLimit = 0;
            } else {
                NSNumber* batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
                self.batchNumLimit = batchNumLimit.integerValue;
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readLevel"]]) {
            
            NSNumber* readLevel = [dictInfo objectForKey:@"readLevel"];
            self.readLevel = readLevel.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
            
            self.goodsType = [dictInfo objectForKey:@"goodsType"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dayNum"]]) {
            
            if ([[dictInfo objectForKey:@"dayNum"] isKindOfClass:[NSString class]]) {
                self.dayNum = 0;
            } else {
                NSNumber* dayNum = [dictInfo objectForKey:@"dayNum"];
                self.dayNum = dayNum.integerValue;
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
            self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"withinDays"]]) {
            
            NSNumber * withinDayNum = dictInfo[@"withinDays"];
            
            self.withinDays = withinDayNum.integerValue;
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         
    }

    

}


@end


#pragma mark -
#pragma mark CommodityGroup

@implementation CommodityGroup

+ (CommodityGroup*)newGroupWithCommodity:(Commodity*)commodity {

    CommodityGroup* newGroup = [[CommodityGroup alloc]init];

    newGroup.dayNum = commodity.dayNum;
    [newGroup.commodityList addObject:commodity];

    return newGroup;
}

- (id)init {
    self = [super init];
    if (self) {
        self.commodityList = [NSMutableArray array];
    }

    return self;
}

@end

#pragma mark -
#pragma mark CommodityGroupListDTO

@implementation CommodityGroupListDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    if (!dictInfo) {
        return;
    }

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {

        NSNumber* totalCount = [dictInfo objectForKey:@"totalCount"];
        self.totalCount = totalCount.integerValue;
    }

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeStartTime"]]) {
        self.closeStartTime = [dictInfo objectForKey:@"closeStartTime"];
    }

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeEndTime"]]) {
        self.closeEndTime = [dictInfo objectForKey:@"closeEndTime"];
    }

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"operateStatus"]]) {
        self.operateStatus = [dictInfo objectForKey:@"operateStatus"];
    }

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodslist"]]) {

        NSArray* goodsDictList = [dictInfo objectForKey:@"goodslist"];

        self.groupList = [NSMutableArray array];

        for (NSDictionary* goodsInfoDict in goodsDictList) {
            Commodity* goodsInfo = [[Commodity alloc]initWithDictionary:goodsInfoDict];
            [self addCommodityToSuitableGroupByDayNum:goodsInfo];
        }
    }

    [self.groupList sortUsingComparator:^NSComparisonResult(CommodityGroup* obj1, CommodityGroup* obj2) {
        return obj1.dayNum > obj2.dayNum ? NSOrderedDescending : NSOrderedAscending;
    }];
}

- (void)addCommoditiesFromDictionary:(NSDictionary*)otherDictionary {
    if (!otherDictionary) {
        return;
    }

    if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"totalCount"]]) {

        NSNumber* totalCount = [otherDictionary objectForKey:@"totalCount"];
        self.totalCount = totalCount.integerValue;
    }

    if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"closeStartTime"]]) {
        self.closeStartTime = [otherDictionary objectForKey:@"closeStartTime"];
    }

    if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"closeEndTime"]]) {
        self.closeEndTime = [otherDictionary objectForKey:@"closeEndTime"];
    }

    if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"operateStatus"]]) {
        self.operateStatus = [otherDictionary objectForKey:@"operateStatus"];
    }

    if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"goodslist"]]) {

        NSArray* goodsDictList = [otherDictionary objectForKey:@"goodslist"];

        for (NSDictionary* goodsInfoDict in goodsDictList) {
            Commodity* goodsInfo = [[Commodity alloc]initWithDictionary:goodsInfoDict];
            [self addCommodityToSuitableGroupByDayNum:goodsInfo];
        }
    }

    [self.groupList sortUsingComparator:^NSComparisonResult(CommodityGroup* obj1, CommodityGroup* obj2) {
        return obj1.dayNum > obj2.dayNum ? NSOrderedDescending : NSOrderedAscending;
    }];
}

- (void)addCommodityToSuitableGroupByDayNum:(Commodity*)commodity {
    CommodityGroup* suitableGroup = nil;
    for (CommodityGroup* groupInfo in self.groupList) {
        if (groupInfo.dayNum == commodity.dayNum) {
            suitableGroup = groupInfo;
            break;
        }
    }

    if (suitableGroup) {
        [suitableGroup.commodityList addObject:commodity];
    } else {
        CommodityGroup* newGroup = [CommodityGroup newGroupWithCommodity:commodity];
        [self.groupList addObject:newGroup];
    }
}

- (NSInteger)loadedItemsAmount {
    NSInteger loadedItemsCount = 0;
    for (CommodityGroup* groupInfo in self.groupList) {
        loadedItemsCount += groupInfo.commodityList.count;
    }

    return loadedItemsCount;
}

- (BOOL)isLoadedAll {

    if ([self loadedItemsAmount] == self.totalCount) {
        return YES;
    }

    return NO;
}

- (NSInteger)nextPage {
    return [self loadedItemsAmount] / customPageSize + 1;
}

@end
