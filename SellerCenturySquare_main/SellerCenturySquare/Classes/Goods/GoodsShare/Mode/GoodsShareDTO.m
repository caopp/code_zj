//
//  GoodsShareDTO.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsShareDTO.h"

@implementation GoodsShareDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"labelId"]]) {
                
                self.labelId = [dictInfo objectForKey:@"labelId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"userId"]]) {
                
                self.userId = [dictInfo objectForKey:@"userId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"userName"]]) {
                
                self.userName = [dictInfo objectForKey:@"userName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"iconUrl"]]) {
                
                self.iconUrl = [dictInfo objectForKey:@"iconUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"wPicNum"]]) {
                
                self.wPicNum = [dictInfo objectForKey:@"wPicNum"];
            }
            
            
            if ([self checkLegitimacyForData:dictInfo[@"rPicNum"]]) {
                
                self.rPicNum = dictInfo[@"rPicNum"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"status"]]) {
                
                self.status = dictInfo[@"status"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsNo"]]) {
                
                self.goodsNo = dictInfo[@"goodsNo"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsName"]]) {
                
                self.goodsName = dictInfo[@"goodsName"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"imgUrl"]]) {
                
                self.imgUrl = dictInfo[@"imgUrl"];
            }
            
            
            if ([self checkLegitimacyForData:dictInfo[@"color"]]) {
                
                self.color = dictInfo[@"color"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsWillNo"]]) {
                
                self.goodsWillNo = dictInfo[@"goodsWillNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"retailPrice"]]) {
                
                self.retailPrice = dictInfo[@"retailPrice"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"isComm"]]) {
                
                self.isComm = dictInfo[@"isComm"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"userType"]]) {
                
                self.userType = dictInfo[@"userType"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"commPercent"]]) {
                
                self.commPercent = dictInfo[@"commPercent"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"createDate"]]) {
                
                self.createDate = dictInfo[@"createDate"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"auditDate"]]) {
                
                self.auditDate = dictInfo[@"auditDate"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"sharedGoodsNum"]]) {
                
                self.sharedGoodsNum = dictInfo[@"sharedGoodsNum"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"shareNum"]]) {
                
                self.shareNum = dictInfo[@"shareNum"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"auditPassNum"]]) {
                
                self.auditPassNum = dictInfo[@"auditPassNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"picList"];
                NSMutableArray *listArr = [[NSMutableArray alloc]init];

                NSMutableArray *windownArr = [[NSMutableArray alloc]init];
                NSMutableArray *referenceArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *tmpDic in list) {
                    
                    GoodsSharePicDTO *imgDTO = [[GoodsSharePicDTO alloc]init];
                    [imgDTO setDictFrom:tmpDic];
                    [listArr addObject:imgDTO];
                    if ([imgDTO.imageType intValue]==1) {
                        [windownArr addObject:imgDTO];
                    }else{
                        [referenceArr addObject:imgDTO];
                    }
                }
                self.windownList = windownArr;
                self.referenceList = referenceArr;
                self.picList = listArr;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
