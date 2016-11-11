//
//  PersonlCeterSetSingle.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PersonlCeterSetSingle.h"

@implementation PersonlCeterSetSingle

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon 
{
    PersonlCeterSetSingle *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}
@end
