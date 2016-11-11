//
//  GetRecommendRecordListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetRecommendRecordListDTO.h"
#import "RecommendRecordDTO.h"

@implementation GetRecommendRecordListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.recommendRecordDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"recommendList"]]) {
                
                NSMutableArray *resultList = [[NSMutableArray alloc]init];
                
                NSMutableArray *list = [dictInfo objectForKey:@"recommendList"];
                
                for (NSMutableDictionary *tmpDic in list) {
                    
                    RecommendRecordDTO *recommendRecordDTO = [[RecommendRecordDTO alloc ]init];
                    
                    [recommendRecordDTO setDictFrom:tmpDic];
                    
                    [resultList addObject:recommendRecordDTO];
                    
                }
                
                self.recommendRecordDTOList = resultList;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
