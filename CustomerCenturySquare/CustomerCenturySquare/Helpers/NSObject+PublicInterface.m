//
//  NSObject+PublicInterface.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "NSObject+PublicInterface.h"

@implementation NSObject (PublicInterface)

// 判断数据是否合法
- (BOOL)checkLegitimacyForData:(id)object{
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
     
    }
}

//判断数据是否与开发文档（数据类型 一致）
//Empty NSDictionary类型
//NSDictionary 数据类型
//NSString 数据类型
//NSNumber 数据类型
//NSArray  数据类型

- (id) checkLegitimacyForData:(id)sourceData dataType:(BCSDataType)dataType{
    
    BOOL LegitimacyTag = false;
    
    switch (dataType) {
            
        case BCSDictionaryDataType:
        {
            
            LegitimacyTag = (sourceData && [sourceData isKindOfClass:[NSDictionary class]]);
            NSDictionary *targetData = [[NSDictionary alloc] init];
            
            return LegitimacyTag?(NSDictionary*)sourceData:targetData;
           
        }
            
        case BCSStringDataType:
        {

            LegitimacyTag = (sourceData && [sourceData isKindOfClass:[NSString class]]);
            NSString *targetData = [[NSString alloc] init];
            
            return LegitimacyTag?(NSString*)sourceData:targetData;
        }
        case BCSNumberDataType:
        {
            LegitimacyTag = (sourceData && [sourceData isKindOfClass:[NSNumber class]]);
            NSNumber *targetData = [[NSNumber alloc] initWithInt: -1];
            
            return LegitimacyTag?(NSNumber*)sourceData:targetData;
        }
        case BCSArrayDataType:
        {
            LegitimacyTag = (sourceData && [sourceData isKindOfClass:[NSArray class]]);
            NSArray *targetData = [[NSArray alloc] init];
            
            return LegitimacyTag?(NSArray*)sourceData:targetData;
        }
       
            
        default:
            break;
    }
    
    return nil;
}
@end
