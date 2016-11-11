//
//  GetInvMobileListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetInvMobileListDTO.h"
#import "GetInvMobileDTO.h"

@implementation GetInvMobileListDTO

- (void)setGetInvMobileDTOList:(NSMutableArray *)getInvMobileDTOList{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *banArr = [[NSMutableArray alloc]init];
    
    
    long count = [getInvMobileDTOList count];
    
    long banInviteCount = 0;
    
    for (int index = 0 ; index < count; index ++) {
        
        GetInvMobileDTO *getInvMobileDTO = [[GetInvMobileDTO alloc] init];
        NSDictionary *dictionary = [getInvMobileDTOList objectAtIndex:index];
        [getInvMobileDTO setDictFrom:dictionary];
        
        if ([getInvMobileDTO.invOpt isEqualToString:@"1"]) {
            
            banInviteCount ++;
            [banArr addObject:getInvMobileDTO];
            
        }else{
            
            [arr addObject:getInvMobileDTO];
        
        }
        
        
    }
    
    _getInvMobileDTOList = arr;// !可以接受邀请的
    _banInviteDTOList = banArr;// !不可以接受邀请的
    
    
    self.count = count;
    
    self.banInviteCount = banInviteCount;// !不需要发送邀请码的人数
    
}
@end
