//
//  BasicDTO.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+PublicInterface.h"

@interface BasicDTO : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;

/**
 *  赋值
 *
 *  @param dictInfo 传入字典
 */
- (void)setDictFrom:(NSDictionary *)dictInfo;

@end
