//
//  MerchantListDetailsDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantListDetailsDTO.h"

@implementation MerchantListDetailsDTO


// !重写父类的方法  把数据转换成dto
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            // !id,类型为int
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.id = [dictInfo objectForKey:@"id"];
            }
            // !商家编码
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            // !商家名称
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            // !商家图片路径
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"pictureUrl"]]) {
                
                self.pictureUrl = [dictInfo objectForKey:@"pictureUrl"];
            }
            // !商家类别名称
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            // !商品数量,类型为int
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNum"]]) {
                
                self.goodsNum = [dictInfo objectForKey:@"goodsNum"];
            }
            // !营业状态(0:营业 1:歇业)
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"operateStatus"]]) {
                
                self.operateStatus = [dictInfo objectForKey:@"operateStatus"];
            }
            // !歇业开始时间（yyyy-MM-dd mm:hh:ss）
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeStartTime"]]) {
                
                self.closeStartTime = [dictInfo objectForKey:@"closeStartTime"];
            }
            // !歇业结束时间
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeEndTime"]]) {
                
                self.closeEndTime = [dictInfo objectForKey:@"closeEndTime"];
            }
            // !0:黑名单 1正常
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"blacklistFlag"]]) {
                
                self.blacklistFlag = [dictInfo objectForKey:@"blacklistFlag"];
            }
            // !  0正常、1推荐、2上新
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"flag"]]) {
                
                self.flag = [dictInfo objectForKey:@"flag"];
            }
            // !档口号
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stallNo"]]) {
                
                self.stallNo = [dictInfo objectForKey:@"stallNo"];
            }
            
            // !商家状态 (0:开启 1:关闭)
            if ([self checkLegitimacyForData:dictInfo[@"merchantStatus"]]) {
                
                self.merchantStatus = dictInfo[@"merchantStatus"];
                
            }
            
            //!是否收藏
            if ([self checkLegitimacyForData:dictInfo[@"isFavorite"]]) {
                
                self.isFavorite = dictInfo[@"isFavorite"];
                
            }
            
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
