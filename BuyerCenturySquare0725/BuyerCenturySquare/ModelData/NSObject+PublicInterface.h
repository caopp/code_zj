//
//  NSObject+PublicInterface.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, BCSDataType) {
    
    BCSEmptyDictionaryDataType = 0,              //Empty NSDictionary类型 0
    BCSDictionaryDataType,                       //NSDictionary 数据类型 0
    BCSStringDataType,                           //NSString 数据类型 2
    BCSNumberDataType,                           //NSNumber 数据类型 3
    BCSArrayDataType                             //NSArray  数据类型 4
};

@interface NSObject (PublicInterface)

/**
 *  检查数据合法
 *
 *  @param object 传入数据（判断数据是否存在 或者 是否为NSNull）
 *
 *  @return YES(数据合法)，NO(数据不合法)
 */
- (BOOL)checkLegitimacyForData:(id)object;
- (id)checkLegitimacyForData:(id )sourceData dataType:(BCSDataType)dataType;

@end
