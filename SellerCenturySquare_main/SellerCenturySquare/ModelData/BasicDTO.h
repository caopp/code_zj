//
//  BasicDTO.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+PublicInterface.h"
#import "UIImageView+WebCache.h"

@interface BasicDTO : NSObject

- (id)initWithDictionary:(NSDictionary*)dictInfo;

/**
 *  赋值
 *
 *  @param dictInfo 传入字典
 */
- (void)setDictFrom:(NSDictionary *)dictInfo;

/**
 *  将数据转为nsstring
 *
 *  @param data nsstirng、nsnumber、nsnull
 *
 *  @return 返回nsstring
 */
- (NSString *)transformationData:(id)data;

@end
