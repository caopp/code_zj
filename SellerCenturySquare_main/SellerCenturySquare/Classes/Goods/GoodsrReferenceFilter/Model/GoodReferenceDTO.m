//
//  GoodReferenceDTO.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodReferenceDTO.h"

@implementation GoodReferenceDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSetWPic"]]) {
            
            self.isSetWPic = [dictInfo objectForKey:@"isSetWPic"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSetRPic"]]) {
            
            self.isSetRPic = [dictInfo objectForKey:@"isSetRPic"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
            
            self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
            
            self.goodsName = [dictInfo objectForKey:@"goodsName"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
            
            self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
            
            self.color = [dictInfo objectForKey:@"color"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
            
            self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"retailPrice"]]) {
            
            self.retailPrice = [dictInfo objectForKey:@"retailPrice"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
            
            self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picNum"]]) {
            
            self.picNum = [dictInfo objectForKey:@"picNum"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"setWNum"]]) {
            
            self.setWNum = [dictInfo objectForKey:@"setWNum"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"setRNum"]]) {
            
            self.setRNum = [dictInfo objectForKey:@"setRNum"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"wQty"]]) {
            
            self.wQty = [dictInfo objectForKey:@"wQty"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"rQty"]]) {
            
            self.rQty = [dictInfo objectForKey:@"rQty"];
        }
    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end
