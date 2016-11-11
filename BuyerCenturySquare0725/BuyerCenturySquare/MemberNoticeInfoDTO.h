//
//  MemberNoticeInfoDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberNoticeInfoDTO : BasicDTO

/**
 *  表识ID(类型为Long)
 */
@property(nonatomic,strong) NSNumber* id;
/**
 *  标题
 */
@property(nonatomic,copy)NSString *infoTitle;

/**
 *  内容
 */
@property(nonatomic,copy)NSString *infoContent;

/**
 *  发送时间
 */
@property(nonatomic,copy)NSString *sendTime;

/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *createDate;

/**
 *  阅读状态 1未读，2已读
 */
@property(nonatomic,copy)NSString *readStatus;
/**
 *  列表图
 */
@property(nonatomic,copy)NSString *listPic;
@end
