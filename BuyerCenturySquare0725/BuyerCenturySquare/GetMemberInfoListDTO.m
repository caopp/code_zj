//
//  GetMemberInfoDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberInfoListDTO.h"

@implementation GetMemberInfoListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.MemberInfoDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}


@end
