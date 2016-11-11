//
//  InviteContactInfoDTO.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface InviteContactInfoDTO : BasicDTO

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *phoneNum;

@property(nonatomic,assign)NSInteger shopLevel;

@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,assign)NSInteger row;

@end
