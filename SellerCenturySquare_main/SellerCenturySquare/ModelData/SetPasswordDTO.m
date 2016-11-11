//
//  SetPasswordDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetPasswordDTO.h"

@implementation SetPasswordDTO

static SetPasswordDTO *setPasswordDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        setPasswordDTO = [[self alloc] init];
    });
    return setPasswordDTO;
}


@end
