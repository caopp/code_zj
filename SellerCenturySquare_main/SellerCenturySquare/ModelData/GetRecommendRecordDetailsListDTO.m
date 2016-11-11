//
//  GetRecommendRecordDetailsListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetRecommendRecordDetailsListDTO.h"
#import "GoodsPicDTO.h"
#import "RecommendRecordDetailsDTO.h"

@implementation GetRecommendRecordDetailsListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.goodsPicDTOList = [[NSMutableArray alloc]init];
        self.recommendMemberDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNum"]]) {
                
                self.goodsNum = [dictInfo objectForKey:@"goodsNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNum"]]) {
                
                self.memberNum = [dictInfo objectForKey:@"memberNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createDate"]]) {
                
                self.createDate = [dictInfo objectForKey:@"createDate"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"content"]]) {
                
                self.content = [dictInfo objectForKey:@"content"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsPicList"]]) {
                
                NSMutableArray *resultArr = [[NSMutableArray alloc]init];
                
                NSMutableArray *list = [dictInfo objectForKey:@"goodsPicList"];
                
                for (NSDictionary *tmpDic in list) {
                    
                    GoodsPicDTO *goodsPicDTO = [[GoodsPicDTO alloc]init];
                    
                    [goodsPicDTO setDictFrom:tmpDic];
                    
                    [resultArr addObject:goodsPicDTO];
                }
                
                self.goodsPicDTOList = resultArr;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"recommendMemberList"]]) {
                
                NSMutableArray *resultArr = [[NSMutableArray alloc]init];
                
                NSMutableArray *list = [dictInfo objectForKey:@"recommendMemberList"];
                
                for (NSDictionary *tmpDic in list) {
                    
                    RecommendMemberDTO *recMemeberDTO = [[RecommendMemberDTO alloc]init];
                    
                    [recMemeberDTO setDictFrom:tmpDic];
                    
                    [resultArr addObject:recMemeberDTO];
                }
                
                self.recommendMemberDTOList = resultArr;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
