//
//  GetMemberInviteListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberInviteListDTO.h"
#import "MemberInviteDTO.h"
@implementation GetMemberInviteListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberInviteDTOList = [[NSMutableArray alloc]init];
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
                
                self.memberInviteDTOList = [dictInfo objectForKey:@"list"];
                
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *tmpDic in self.memberInviteDTOList) {
                    
                    MemberInviteDTO *memberInviteDTO = [[MemberInviteDTO alloc ]init];
                    
                    [memberInviteDTO setDictFrom:tmpDic];
                    
                    [arr addObject:memberInviteDTO];
                }
                
                self.memberInviteDTOList = arr;
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
