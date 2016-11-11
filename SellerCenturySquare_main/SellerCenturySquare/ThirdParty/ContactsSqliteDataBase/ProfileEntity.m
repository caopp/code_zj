//
//  ProfileEntity.h
//  ContactsSqliteDatabase
//
//  Created by mac on 14-6-19.
//  Copyright (c) 2014年 李春晓. All rights reserved.
//

#import "ProfileEntity.h"


@implementation ProfileEntity

static ProfileEntity *profileEntity = nil;
+(ProfileEntity*)shareInstance
{
    if (profileEntity==nil)
    {
        profileEntity = [[ProfileEntity alloc]init];
    }
    return profileEntity;
}
@end
