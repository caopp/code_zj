//
//  AuthoriseManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AuthoriseStatus) {
    
    AuthoriseAvailableStatusUnknown     = -1,

    AuthoriseAvailableStatusPass = 0,
    AuthoriseAvailableStatusLeaveNeed1  = 1,
    AuthoriseAvailableStatusLeaveNeed2  = 2,
    AuthoriseAvailableStatusLeaveNeed3  = 3,
    AuthoriseAvailableStatusLeaveNeed4  = 4,
    AuthoriseAvailableStatusLeaveNeed5  = 5,
    AuthoriseAvailableStatusLeaveNeed6  = 6,
};

@interface AuthoriseManager : NSObject

/**
 *  判断当前用户的权限水平是否在某一个等级.
 *
 *  @param necessaryLevel 用户需要满足的等级
 *
 *  @return 判断结果,AuthoriseStatus.
 */
+ (AuthoriseStatus)AuthUserLevel:(NSInteger)necessaryLevel;

@end
