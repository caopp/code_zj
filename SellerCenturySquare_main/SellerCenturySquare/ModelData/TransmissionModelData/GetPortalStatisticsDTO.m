//
//  GetPortalStatisticsDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPortalStatisticsDTO.h"

@implementation GetPortalStatisticsDTO

- (id)init{
    self = [super init];
    if (self) {
      
        self.memberDTOList = [[NSMutableArray alloc]init];
        self.goodsSellDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"days3"]]) {
                
                self.threeDaysStatistics = [dictInfo objectForKey:@"days3"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"days7"]]) {
                
                self.sevenDayStatistics = [dictInfo objectForKey:@"days7"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"days30"]]) {
                
                self.thirtyDaysStatistics = [dictInfo objectForKey:@"days30"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"all"]]) {
                
                self.allDaysStatistics = [dictInfo objectForKey:@"all"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberList"]]) {
                
                self.memberDTOList = [dictInfo objectForKey:@"memberList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsSellList"]]) {
                
                self.goodsSellDTOList = [dictInfo objectForKey:@"goodsSellList"];
            }

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
