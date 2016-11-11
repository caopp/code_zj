//
//  AreaInfoDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 10/19/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface AreaInfoDTO : BasicDTO

@property (nonatomic, assign)NSInteger id;
@property (nonatomic, strong)NSString* name;
@property (nonatomic, assign)NSInteger parentId;
@property (nonatomic, assign)NSInteger sort;
@property (nonatomic, strong)NSString* type;
@property (nonatomic, strong)NSMutableArray* subAreaInfo;

@end

@interface AreaInfoList : BasicDTO

@property (nonatomic, strong)NSMutableArray* areaList;

-(void)saveToPlist;

@end
