//
//  BasicDTO.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@implementation BasicDTO

- (id)initWithDictionary:(NSDictionary*)dictInfo {
    self = [super init];

    if (self) {
        [self setDictFrom:dictInfo];
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

- (NSString *)transformationData:(id)data{

    if ([data isKindOfClass:[NSString class]]) {
        
        return data;
        
    }else if ([data isKindOfClass:[NSNumber class]]){
        
        NSNumber *number = (NSNumber *)data;
        
        return number.stringValue;
        
    }else{
        
        return @"";
    }
}

@end
