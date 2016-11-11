//
//  UserDetailManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailManager : NSObject

+ (instancetype)shareInstance;

- (void)setUserInfor:(id)value;

@end
