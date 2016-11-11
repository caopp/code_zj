//
//  UserDetailManager.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UserDetailManager.h"

static UserDetailManager *userDetailInstance_;

@implementation UserDetailManager


+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == userDetailInstance_) {
            
            userDetailInstance_ = [[UserDetailManager alloc]init];
        }
    });
    return userDetailInstance_;
}

- (void)setUserInfor:(id)value{

    
}
@end
