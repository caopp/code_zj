//
//  GetPayPayDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPayPayDTO.h"

@implementation GetPayPayDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"payStatus"]]) {
                
                self.payStatus = [[dictInfo objectForKey:@"payStatus"] boolValue];
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"payMethod"]]) {
                
                self.payMethod = [dictInfo objectForKey:@"payMethod"];
                
            }
            
            if ([self.payMethod isEqualToString:@"WeChatMobile"]) {
                
                self.WeChatMobileSignData = [dictInfo objectForKey:@"signData"];
            }
            else
            {
                self.AlipayQuickSignData = [dictInfo objectForKey:@"signData"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
