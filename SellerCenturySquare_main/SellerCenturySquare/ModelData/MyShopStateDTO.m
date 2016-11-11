//
//  MyShopStateDTO.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MyShopStateDTO.h"

@implementation MyShopStateDTO

static MyShopStateDTO *myShopStateDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        myShopStateDTO = [[self alloc] init];
    });
    return myShopStateDTO;
}

@end
