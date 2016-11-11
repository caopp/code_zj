//
//  BaseDTO.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/9.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BaseDTO.h"

@implementation BaseDTO
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
