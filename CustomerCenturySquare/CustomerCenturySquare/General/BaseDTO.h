//
//  BaseDTO.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/9.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+PublicInterface.h"
@interface BaseDTO : NSObject
- (id)initWithDictionary:(NSDictionary*)dictionary;

/**
 *  赋值
 *
 *  @param dictInfo 传入字典
 */
- (void)setDictFrom:(NSDictionary *)dictInfo;
@end
