//
//  MainInfoDTO.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MainInfoDTO.h"

@implementation MainInfoDTO

static MainInfoDTO *mainInfoDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        mainInfoDTO = [[self alloc] init];
    });
    return mainInfoDTO;
}

@end
