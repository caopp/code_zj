//
//  PersonlCeterSetSingle.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonlCeterSetSingle : NSObject
//图标
@property (nonatomic,copy)NSString *icon;
//标题
@property (nonatomic,copy)NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;
@end
