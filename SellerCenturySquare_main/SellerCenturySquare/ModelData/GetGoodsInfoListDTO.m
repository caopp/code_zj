//
//  GetGoodsInfoListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsInfoListDTO.h"
#import "GoodsInfoDTO.h"
#import "AttrListDTO.h"
@implementation GetGoodsInfoListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.stepDTOList = [[NSMutableArray alloc]init];
        self.windowImageList = [[NSMutableArray alloc]init];
        self.objectiveImageList = [[NSMutableArray alloc]init];
        self.referImageList = [[NSMutableArray alloc]init];
        self.skuDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"details"]]) {
                
                self.details = [dictInfo objectForKey:@"details"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"brandName"]]) {
                
                self.brandName = [dictInfo objectForKey:@"brandName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"onSaleTime"]]) {
                
                self.onSaleTime = [dictInfo objectForKey:@"onSaleTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"offSaleTime"]]) {
                
                self.onSaleTime = [dictInfo objectForKey:@"offSaleTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
                
                self.samplePrice = [dictInfo objectForKey:@"samplePrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"defaultPicUrl"]]) {
                
                self.defaultPicUrl = [dictInfo objectForKey:@"defaultPicUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
                
                self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchMsg"]]) {
                
                self.batchMsg = [dictInfo objectForKey:@"batchMsg"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sampleFlag"]]) {
                
                self.sampleFlag = [dictInfo objectForKey:@"sampleFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadAuth"]]) {
                
                self.downloadAuth = [dictInfo objectForKey:@"downloadAuth"];
            }
            
            
            //id stepDTOList = [data objectForKey:@"stepList"];
            
            //判断数据合法 steplist
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stepList"]]) {
                
                NSMutableArray *stepList = [dictInfo objectForKey:@"stepList"];
                NSMutableArray *stepListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *stepDic in stepList) {
                    
                    StepDTO *stepDTO = [[StepDTO alloc]init];
                    
                    [stepDTO setDictFrom:stepDic];
                    
                    [stepListArr addObject:stepDTO];
                }
                self.stepDTOList = stepListArr;
            }
            
            //判断数据合法 windowImageList
           // id windowImageList = [data objectForKey:@"windowImageList"];
            
           if ([self checkLegitimacyForData:[dictInfo objectForKey:@"windowImageList"]]) {
               
               NSMutableArray *windowImageList = [dictInfo objectForKey:@"windowImageList"];
               NSMutableArray *windowImageListArr = [[NSMutableArray alloc]init];
               for (NSDictionary *windowImageDic in windowImageList) {
                   
                    PicDTO *picDTO = [[PicDTO alloc]init];
                    
                    [picDTO setDictFrom:windowImageDic];
                    
                    [windowImageListArr addObject:picDTO];
                }
               self.windowImageList = windowImageListArr;
            }
            
            //判断数据合法 objectiveImageList
           // id objectiveImageList = [data objectForKey:@"objectiveImageList"];
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"objectiveImageList"]]) {
                
                NSMutableArray *objectiveImageList = [dictInfo objectForKey:@"objectiveImageList"];
                NSMutableArray *objectiveImageListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *objectiveImageDic in objectiveImageList) {

                    
                    PicDTO *picDTO = [[PicDTO alloc]init];
                    
                    [picDTO setDictFrom:objectiveImageDic];
                    
                    [objectiveImageListArr addObject:picDTO];
                }
                self.objectiveImageList = objectiveImageListArr;
            }
            
            //判断数据合法 referImageList
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"referImageList"]]) {
                
                NSMutableArray *referImageList = [dictInfo objectForKey:@"referImageList"];
                NSMutableArray *referImageListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *referImageDic in referImageList) {
                    
                    PicDTO *picDTO = [[PicDTO alloc]init];
                    
                    [picDTO setDictFrom:referImageDic];
                    
                    [referImageListArr addObject:picDTO];
                }
                self.referImageList = referImageListArr;
            }
            
            //判断数据合法 skuList
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                NSMutableArray *skuList = [dictInfo objectForKey:@"skuList"];
                NSMutableArray *skuListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *skuDic in skuList) {
                    
                    SkuDTO *skuDTO = [[SkuDTO alloc]init];
                    
                    [skuDTO setDictFrom:skuDic];
                    
                    [skuListArr addObject:skuDTO];
                }
                self.skuDTOList = skuListArr;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"attrList"]]) {
                
                NSMutableArray *attrList = [dictInfo objectForKey:@"attrList"];
                NSMutableArray *attrListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in attrList) {
                    
                    AttrListDTO *attrListDTO = [[AttrListDTO alloc]init];
                    [attrListDTO setDictFrom:tmpDic];
                    
                    [attrListArr addObject:attrListDTO];
                }
                self.attrList = attrListArr;
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"brandNo"]]) {
                
                self.brandNo = dictInfo[@"brandNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"ftTemplateId"]]) {
                
              self.ftTemplateId =  [NSString stringWithFormat:@"%@",dictInfo[@"ftTemplateId"]];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsWeight"]]) {
                
                self.goodsWeight = dictInfo[@"goodsWeight"];

            }
            
            if ([self checkLegitimacyForData:dictInfo[@"price1"]]) {
                self.price1 = dictInfo[@"price1"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price2"]]) {
                
                self.price2 = dictInfo[@"price2"];
            
            }
            if ([self checkLegitimacyForData:dictInfo[@"price3"]]) {
                
                self.price3 =dictInfo[@"price3"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price4"]]) {
                
                self.price4 = dictInfo[@"price4"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price5"]]) {
                
                self.price5 = dictInfo[@"price5"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"price6"]]) {
                
                self.price6 = dictInfo[@"price6"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"channelList"]]) {
                
                self.channelList = dictInfo[@"channelList"];
                
                //!把字符串分割成数组
                self.channelComponArray = [NSMutableArray arrayWithArray:[self.channelList componentsSeparatedByString:@","]];
                
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"retailPrice"]]) {
                
                self.retailPrice = dictInfo[@"retailPrice"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"freeDelivery"]]) {
                
                self.freeDelivery = dictInfo[@"freeDelivery"];
                
            }
            
//            if ([self checkLegitimacyForData:dictInfo[@"vipPriceList"]]) {
//                
//                self.vipPriceList = [NSMutableArray arrayWithCapacity:0];
//                
//                for (NSDictionary * vipDic in dictInfo[@"vipPriceList"]) {
//                    
//                    VIPPriceDTO * vipDTO = [[VIPPriceDTO alloc]init];
//                    [vipDTO setDictFrom:vipDic];
//                    
//                    [self.vipPriceList addObject:vipDTO];
//                    
//                }
//                
//            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(BOOL)getParameterIsLack
{
    if (self.goodsNo == nil || self.goodsStatus == nil || self.goodsName == nil){
        
        return YES;
    }
    
    //样板价格不一定有
    if (self.sampleFlag == nil) {
        return YES;
    }
    
    return NO;
}

-(BOOL)IsLackParameter{
    
    return  [self getParameterIsLack];
}

- (NSMutableArray *)getWindowImage:(NSMutableArray *)windowImage{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<windowImage.count; i++) {
        
        PicDTO *picDto = (PicDTO *)[windowImage objectAtIndex:i];
        
        NSString *imageUrl = picDto.picUrl;
        
        [array addObject:imageUrl];
    }
    return array;
}

- (NSMutableArray *)getObjectiveImage:(NSMutableArray *)objectiveImage{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<objectiveImage.count; i++) {
        
        PicDTO *picDto = (PicDTO *)[objectiveImage objectAtIndex:i];
        
        NSString *imageUrl = picDto.picUrl;
        
        [array addObject:imageUrl];
    }
    
    return array;
    
}


- (NSMutableArray *)getReferImage:(NSMutableArray *)ReferImage{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<ReferImage.count; i++) {
        
        PicDTO *picDto = (PicDTO *)[ReferImage objectAtIndex:i];
        
        NSString *imageUrl = picDto.picUrl;
        if ([picDto.picStatus intValue] ==1) {
             [array addObject:imageUrl];
        }
       
        
    }
    return array;
}

@end

//!会员等级价钱
@implementation VIPPriceDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    @try {
        
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:dictInfo[@"id"]]) {
                
                
                self.ids = dictInfo[@"id"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"level"]]) {
                
                self.level = dictInfo[@"level"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"amount"]]) {
                
                self.amount = dictInfo[@"amount"];
                
            }
        
        }
        
    }
    @catch (NSException *exception) {
        
        
        
        
    }
    @finally {
        
        
    }


}


@end

