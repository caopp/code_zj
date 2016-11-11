//
//  CommodityGroupListDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CommodityGroupListDTO.h"


#pragma mark -
#pragma mark Commodity

@implementation Commodity

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
            
            self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
            
            self.goodsName = [dictInfo objectForKey:@"goodsName"];
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
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sendTime"]]) {
            
            self.sendTime = [dictInfo objectForKey:@"sendTime"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"firstOnsaleTime"]]) {
            
            self.firstOnsaleTime = [dictInfo objectForKey:@"firstOnsaleTime"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"remark"]]) {
            
            if ([[dictInfo objectForKey:@"price"] isKindOfClass:[NSString class]]) {
                self.remark = 0;
            } else {
                NSNumber* remark = [dictInfo objectForKey:@"remark"];
                self.remark = remark.integerValue;
            }
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
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"authFlag"]]) {
            
            self.authFlag = [dictInfo objectForKey:@"authFlag"];
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
        
        if ([self checkLegitimacyForData:dictInfo[@"withinDays"]]) {
            
            NSNumber* withinDays = [dictInfo objectForKey:@"withinDays"];
            self.withinDays = withinDays.integerValue;
            
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"recommendFlag"]]) {
            NSNumber* withinDays = [dictInfo objectForKey:@"recommendFlag"];
            self.recommendFlag = withinDays.integerValue;
            
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
// !是否有权限查看
- (BOOL)isReadable {
    if ([self.authFlag isEqualToString:@"0"]) {
        return NO;
    } else if ([[self authFlag] isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
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

- (id)initWithDictionary:(NSDictionary *)dictionary withByDaySave:(BOOL)isByDaySave{
    
    self = [super init];
    if (self) {
        [self setDictFrom:dictionary withByDaySave:isByDaySave];
    }
    
    return self;
}


// !重写父类的方法
-(void)setDictFrom:(NSDictionary *)dictInfo withByDaySave:(BOOL)isByDaySave{
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
            
            NSNumber* totalCount = [dictInfo objectForKey:@"totalCount"];
            self.totalCount = totalCount.intValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodslist"]]) {
            
            NSArray* goodsDictList = [dictInfo objectForKey:@"goodslist"];
            
            self.groupList = [NSMutableArray array];
            
            for (NSDictionary* goodsInfoDict in goodsDictList) {
               
                Commodity* goodsInfo = [[Commodity alloc]initWithDictionary:goodsInfoDict];
                
                if (isByDaySave) {//!按更新时间段存放
                    
                    [self addCommodityToSuitableGroupByDayNum:goodsInfo];

                }else{//!不按更新时间段存放
                
                    [self addCommodityToSuitableGroup:goodsInfo];
                    
                }
                
                
            }
            
            
            
        }
        
//        [self.groupList sortUsingComparator:^NSComparisonResult(CommodityGroup* obj1, CommodityGroup* obj2) {
//            return obj1.dayNum > obj2.dayNum ? NSOrderedDescending : NSOrderedAscending;
//        }];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
// !组合数据
- (void)addCommoditiesFromDictionary:(NSDictionary*)otherDictionary withByDaySave:(BOOL)isByDaySave{
    @try {
        if (!otherDictionary) {
            return;
        }
        // !记录总条数
        if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"totalCount"]]) {
            
            NSNumber* totalCount = [otherDictionary objectForKey:@"totalCount"];
            self.totalCount = totalCount.integerValue;
        }
        // !对数据进行处理  把同一天的放一起
        if ([self checkLegitimacyForData:[otherDictionary objectForKey:@"goodslist"]]) {
            
            NSArray* goodsDictList = [otherDictionary objectForKey:@"goodslist"];
            
            for (NSDictionary* goodsInfoDict in goodsDictList) {
                
                Commodity* goodsInfo = [[Commodity alloc]initWithDictionary:goodsInfoDict];
                
                if (isByDaySave) {//!按更新时间段存放
                    
                    [self addCommodityToSuitableGroupByDayNum:goodsInfo];
                    
                }else{//!不按更新时间段存放
                    
                    [self addCommodityToSuitableGroup:goodsInfo];
                    
                }
                
            }
        }
        
//        [self.groupList sortUsingComparator:^NSComparisonResult(CommodityGroup* obj1, CommodityGroup* obj2) {
//            return obj1.dayNum > obj2.dayNum ? NSOrderedDescending : NSOrderedAscending;
//        }];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
// !将同一个时间段的数据的放一起
- (void)addCommodityToSuitableGroupByDayNum:(Commodity*)commodity {
   
    if ([commodity.goodsType isEqualToString:@"1"]) {//!是补差价
        
        return ;
    }
    
    CommodityGroup* suitableGroup = nil;
    
    for (CommodityGroup* groupInfo in self.groupList) {
        if (groupInfo.dayNum == commodity.dayNum) {//!如果时间相同就加入
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
//!不按时间段存放数据，直接取出存放
-(void)addCommodityToSuitableGroup:(Commodity *)commodity{

    if ([commodity.goodsType isEqualToString:@"1"]) {//!是补差价
        
        return ;
    
    }
    
    CommodityGroup* suitableGroup = nil;

    if (self.groupList.count) {
        
        suitableGroup = self.groupList[0];
    
    }
    
    if (suitableGroup) {
        
        [suitableGroup.commodityList addObject:commodity];
    
    }else{
        
        CommodityGroup* newGroup = [CommodityGroup newGroupWithCommodity:commodity];
        [self.groupList addObject:newGroup];
    }
    
    

}
// !获得总的商品数量
- (NSInteger)loadedItemsAmount {
    
    NSInteger loadedItemsCount = 0;
    // !遍历总的数组里面的小数组，得到每个小数组里面的商品数目
    for (CommodityGroup* groupInfo in self.groupList) {
        loadedItemsCount += groupInfo.commodityList.count;
    }
    
    return loadedItemsCount;
    
}
// !判断是佛已经加载全部了
- (BOOL)isLoadedAll {
    
    if ([self loadedItemsAmount] >= self.totalCount) {
        
        return YES;
    
    }
    
    return NO;
}
// !获取下一页的页码
- (NSInteger)nextPage {
    
    return [self loadedItemsAmount] / 20 + 1;
    
}

@end
