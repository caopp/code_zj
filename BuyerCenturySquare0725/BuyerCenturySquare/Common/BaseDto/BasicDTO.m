//
//  BasicDTO.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@implementation BasicDTO

- (id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {
        [self setDictFrom:dictionary];
    }

    return self;
}
/**
 *  赋值
 *
 *  @param dictInfo 传入字典
 */
- (void)setDictFrom:(NSDictionary *)dictInfo{

    /**
     *  subclass have to full fill this function.
     */
}

@end
