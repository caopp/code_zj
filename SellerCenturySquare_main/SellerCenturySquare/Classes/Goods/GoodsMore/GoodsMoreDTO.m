//
//  GoodsMoreDTO.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "GoodsMoreDTO.h"

@implementation GoodsMoreDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.goodId = [dictInfo objectForKey:@"id"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantListPic"]]) {
                
                self.merchantListPic = [dictInfo objectForKey:@"merchantListPic"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"details"]]) {
                
                self.details = [dictInfo objectForKey:@"details"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"retailPrice"]]) {
                
                self.retailPrice = [dictInfo objectForKey:@"retailPrice"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
                
                self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"defaultPicUrl"]]) {
                
                self.defaultPicUrl = [dictInfo objectForKey:@"defaultPicUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                
                self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStyle"]]) {
                
                self.goodsStyle = [dictInfo objectForKey:@"goodsStyle"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"windowImageList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"windowImageList"];
                NSMutableArray *listArr = [[NSMutableArray alloc]init];
                 NSMutableArray *list_obeject_Arr = [[NSMutableArray alloc]init];
                 NSMutableArray *list_refer_Arr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in list) {
                    
                    ImgDTO *imgDTO = [[ImgDTO alloc]init];
                    [imgDTO setDictFrom:tmpDic];
                    [listArr addObject:imgDTO];
                    if ([imgDTO.isRef isEqualToString:@"1"]) {
                        [list_refer_Arr addObject:imgDTO];
                    }else {
                        [list_obeject_Arr addObject:imgDTO];
                    }
                 
                }
                self.window_objectList = list_obeject_Arr;
                self.window_referList = list_refer_Arr;
                self.windowImageList = listArr;
                
                
            }
            
                
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"objectiveImageList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"objectiveImageList"];
                NSMutableArray *listArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in list) {
                    
                    ImgDTO *imgDTO = [[ImgDTO alloc]init];
                    [imgDTO setDictFrom:tmpDic];
                    [listArr addObject:imgDTO];
                }
                self.objectiveImageList = listArr;
                
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"referImageList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"referImageList"];
                NSMutableArray *listArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in list) {
                    
                    ImgDTO *imgDTO = [[ImgDTO alloc]init];
                    [imgDTO setDictFrom:tmpDic];
                    [listArr addObject:imgDTO];
                }
                self.referImageList = listArr;
                
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"skuList"];
             
                self.skuList = list;
                
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"attrList"]]) {
                
                
                NSMutableArray *list = [dictInfo objectForKey:@"attrList"];
                NSMutableArray *listArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in list) {
                    NSString *strV = [tmpDic objectForKey:@"attrValText"];
                    if (strV&&[strV length]) {
                        AttrDTO *attrDTO = [[AttrDTO alloc]init];
                        [attrDTO setDictFrom:tmpDic];
                        [listArr addObject:attrDTO];
                    }
                    
                }
                self.attrList = listArr;
                
                
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
