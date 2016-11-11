//
//  ChannelDTO.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ChannelDTO.h"

@implementation ChannelDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:dictInfo[@"id"]]) {
            
            self.ids = dictInfo[@"id"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"channelName"]]) {
            
            self.channelName = dictInfo[@"channelName"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"channelImg"]]) {
            
            self.channelImg = dictInfo[@"channelImg"];
        }
    }
    

}


@end
