//
//  HZLocation.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZLocation : NSObject

@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *district;

@property (nonatomic, strong) NSNumber* stateId;
@property (nonatomic, strong) NSNumber* cityId;
@property (nonatomic, strong) NSNumber* districtId;

@end
