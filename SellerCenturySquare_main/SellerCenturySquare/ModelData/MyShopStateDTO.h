//
//  MyShopStateDTO.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MyShopStateDTO : BasicDTO
+ (instancetype)sharedInstance;

@property (nonatomic,assign) BOOL editedState;

@end
