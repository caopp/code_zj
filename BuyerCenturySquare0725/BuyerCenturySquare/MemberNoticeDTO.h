//
//  MemberNoticeDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberNoticeDTO : BasicDTO
/**
 *  表识ID(类型为Long)
 */
@property(nonatomic,strong) NSNumber* Id;
/**
 *  标题
 */
@property(nonatomic,copy)NSString *infoTitle;

/**
 *  内容
 */
@property(nonatomic,copy)NSString *infoContent;

/**
 *  阅读状态1未读，2已读
 */
@property(nonatomic,copy)NSString *readStatus;

/**
 *  发送时间
 */
@property(nonatomic,copy)NSString *sendTime;

/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *createDate;

/**
 *  列表图
 */
@property(nonatomic,copy)NSString *listPic;

/**
 *  类型(1.广告促销 2.申请成功)
 */
@property(nonatomic,copy)NSString *infoType;

//业务编码 （app跳转链接使用）
@property(nonatomic,copy)NSString *businessNo;

//业务类型（1:邀请采购商 2:等级变更 3:采购单发货）
@property(nonatomic,copy)NSString *businessType;

@end
