//
//  GetMemberBlackListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberBlackListDTO.h"
#import "MemberBlackDTO.h"

@implementation GetMemberBlackListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberBlackDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:dictInfo]) {
                
                self.memberBlackDTOList = [dictInfo objectForKey:@"data"];
                
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *tmpDic in self.memberBlackDTOList) {
                    
                    MemberBlackDTO *memberBlackDTO = [[MemberBlackDTO alloc ]init];
                    
                    [memberBlackDTO setDictFrom:tmpDic];
                    
                    [arr addObject:memberBlackDTO];
                }
                
                self.totalCount = [NSNumber numberWithInteger:arr.count];
                self.memberBlackDTOList = arr;
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
