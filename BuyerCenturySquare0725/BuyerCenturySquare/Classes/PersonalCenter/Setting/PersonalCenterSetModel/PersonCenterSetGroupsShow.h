//
//  PersonCenterSetGroupsShow.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterSetGroupsShow : NSObject
//组头
@property (nonatomic,copy) NSString *header;
//组尾
@property (nonatomic,copy) NSString *footer;

//数组(放每组的行模型)
@property (nonatomic,strong)NSArray *items;

+(instancetype)groupShow;
@end
