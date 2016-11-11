//
//  StoreTagModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "StoreTagModel.h"

@implementation StoreTagModel

- (void)setDictFrom:(NSDictionary *)dictInfo{
  
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"flag"]]) {
                
                self.flag = [dictInfo objectForKey:@"flag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"labelName"]]) {
                
                self.labelName = [dictInfo objectForKey:@"labelName"];
            }
    }
}

-(BOOL)getParameterIsLack
{
    if ([self.Id isEqual: @""] || [self.flag isEqual: @""]||[self.labelName isEqual: @""]){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
