//
//  GetMemberTradeListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberTradeListDTO.h"
#import "MemberTradeDTO.h"
@implementation GetMemberTradeListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberTradeDTOList = [[NSMutableArray alloc]init];
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.memberTradeDTOList = [dictInfo objectForKey:@"list"];
                
                NSMutableArray *memberArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *tmpDic in self.memberTradeDTOList) {
                    
                    MemberTradeDTO *memberTradeDTO = [[MemberTradeDTO alloc ]init];
                    
                    [memberTradeDTO setDictFrom:tmpDic];
                    
                    [memberArr addObject:memberTradeDTO];
                }
                
                self.memberTradeDTOList = memberArr;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    
}
@end
