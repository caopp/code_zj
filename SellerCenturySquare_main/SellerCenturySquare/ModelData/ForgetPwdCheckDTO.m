//
//  ForgetPwdCheckDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ForgetPwdCheckDTO.h"

@implementation ForgetPwdCheckDTO

static ForgetPwdCheckDTO *forgetPwdCheckDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        forgetPwdCheckDTO = [[self alloc] init];
    });
    return forgetPwdCheckDTO;
}

@end
