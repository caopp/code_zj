//
//  CSPFeedBackTypeDTO.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPFeedBackTypeDTO.h"

@implementation CSPFeedBackTypeDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
        
        self.type = [dictInfo objectForKey:@"type"];
        
    }
    
    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"typeName"]]) {
        
        self.typeName = [dictInfo objectForKey:@"typeName"];
        
    }
}

@end
