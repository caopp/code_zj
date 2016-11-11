//
//  ChatHistory.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ChatHistory : BasicDTO

/**
 *  发送方
 */
@property(nonatomic,copy)NSString* from;
/**
 *  接收方
 */
@property(nonatomic,copy)NSString* to;

/**
 *  最后接收时间
 */
@property(nonatomic,copy)NSString* time;

/**
 *  当前页码(默认1)
 */
@property(nonatomic,strong)NSNumber *pageNo;

/**
 *  每页显示数量(默认20条)
 */
@property(nonatomic,strong)NSNumber *pageSize;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end
