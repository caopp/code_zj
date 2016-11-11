//
//  WeChatMobilePayDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface WeChatMobilePayDTO : BasicDTO

@property(nonatomic,copy) NSString *appId;
@property(nonatomic,copy) NSString *nonceStr;
@property(nonatomic,copy) NSString *package;
@property(nonatomic,copy) NSString *partnerId;
@property(nonatomic,copy) NSString *prepayId;
@property(nonatomic,copy) NSString *sign;
@property(nonatomic,copy) NSString *timeStamp;

@end
