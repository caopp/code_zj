//
//  MemberDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberDTO : BasicDTO

//小b 名称
@property(nonatomic,copy)NSString* memberName;
//小b 编码
@property(nonatomic,copy)NSString* memberNo;
//金额总量
@property(nonatomic,strong)NSNumber *amount;
//排名
@property(nonatomic,strong)NSNumber *sort;

@end
