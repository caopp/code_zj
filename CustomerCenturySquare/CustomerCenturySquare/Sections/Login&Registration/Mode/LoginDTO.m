//
//  LoginDTO.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/10.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "LoginDTO.h"

@implementation LoginDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.sid = [dictInfo objectForKey:@"skuNo"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}
@end
