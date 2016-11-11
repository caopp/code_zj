//
//  UserProfileDTO.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface UserProfileDTO : BasicDTO

@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *memberNo;
@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *telephone;
@property(nonatomic,copy)NSString *wechatNo;
@property(nonatomic,copy)NSString *provinceNo;
@property(nonatomic,copy)NSString *cityNo;
@property(nonatomic,copy)NSString *countyNo;
@property(nonatomic,copy)NSString *detailAddress;
@property(nonatomic,copy)NSString *postalCode;
@property(nonatomic,copy)NSString *memberLevel;

@end
