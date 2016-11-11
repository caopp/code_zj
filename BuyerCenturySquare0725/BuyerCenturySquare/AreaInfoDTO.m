//
//  AreaInfoDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 10/19/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "AreaInfoDTO.h"

@implementation AreaInfoDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{

    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {

                NSNumber* idNum = [dictInfo objectForKey:@"id"];
                self.id = idNum.integerValue;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"name"]]) {

                self.name = [dictInfo objectForKey:@"name"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"parentId"]]) {

                NSNumber* parentIdNum = [dictInfo objectForKey:@"parentId"];
                self.parentId = parentIdNum.integerValue;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                NSNumber* sort = [dictInfo objectForKey:@"sort"];
                self.sort = sort.integerValue;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {

                self.type = [dictInfo objectForKey:@"type"];
            }
        }

    }
    @catch (NSException *exception) {

    }
    @finally {

    }
}

@end

@implementation AreaInfoList

- (void)setDictFrom:(NSDictionary *)dictInfo{

    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
                NSArray* areaListDict = [dictInfo objectForKey:@"data"];
                self.areaList = [NSMutableArray array];
                for (NSDictionary* areaInfoDict in areaListDict) {
                    AreaInfoDTO* areaInfo = [[AreaInfoDTO alloc]initWithDictionary:areaInfoDict];
                    [self.areaList addObject:areaInfo];
                }
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSMutableArray*)convertToPlistData {
    NSMutableArray * states = [NSMutableArray array];
    for (AreaInfoDTO* stateInfo in self.areaList) {
        NSMutableDictionary* stateInfoDict = [NSMutableDictionary dictionary];
        [stateInfoDict setObject:[NSNumber numberWithInteger:stateInfo.id] forKey:@"stateId"];
        [stateInfoDict setObject:stateInfo.name forKey:@"stateName"];
        NSMutableArray* cities = [NSMutableArray array];
        for (AreaInfoDTO* cityInfo in stateInfo.subAreaInfo) {
            NSMutableDictionary* cityInfoDict = [NSMutableDictionary dictionary];
            [cityInfoDict setObject:[NSNumber numberWithInteger:cityInfo.id] forKey:@"cityId"];
            [cityInfoDict setObject:cityInfo.name forKey:@"cityName"];
            NSMutableArray* areas = [NSMutableArray array];
            for (AreaInfoDTO* areaInfo in cityInfo.subAreaInfo) {
                NSMutableDictionary* areaInfoDict = [NSMutableDictionary dictionary];
                [areaInfoDict setObject:[NSNumber numberWithInteger:areaInfo.id] forKey:@"areaId"];
                [areaInfoDict setObject:areaInfo.name forKey:@"areaName"];
                [areas addObject:areaInfoDict];
            }
            [cityInfoDict setObject:areas forKey:@"areas"];

            [cities addObject:cityInfoDict];
        }
        [stateInfoDict setObject:cities forKey:@"cities"];

        [states addObject:stateInfoDict];
    }

    return states;
}

- (void)saveToPlist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath1= [paths objectAtIndex:0];

    //得到完整的路径名
    NSString *fileName = [plistPath1 stringByAppendingPathComponent:@"areaInfo.plist"];

    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fileName]) {
        NSArray* content = [self convertToPlistData];
        [content writeToFile:fileName atomically:YES];
    } else {
        if ([fm createFileAtPath:fileName contents:nil attributes:nil]) {

            NSArray* content = [self convertToPlistData];
            [content writeToFile:fileName atomically:YES];
        } else {
            NSLog(@"创建下载日志文件失败");
        }
    }
}

@end
