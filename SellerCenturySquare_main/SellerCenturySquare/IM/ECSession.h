//
//  ECSession.h
//  CCPiPhoneSDK
//
//  Created by wang ming on 14-12-10.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ECSession : NSObject

/***
 聊天 对象
 ****/
@property (nonatomic, copy) NSString *jid;

/**
 @property
 @brief 货号 即 会话名称
 */
@property (nonatomic, copy) NSString *goodNo;

@property(nonatomic,copy)NSString *goodsWillNo;
/**
 @property
 @brief 会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 @property
 @brief 创建时间 显示的时间 毫秒
 */
@property (nonatomic, assign) long long dateTime;

/**
 @property
 @brief 与消息表type一样
 */
@property (nonatomic, assign) int type;

/**
 @property
 @brief 显示的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 @property
 @brief 未读消息数
 */
@property (nonatomic,assign) NSInteger unreadCount;

/**
 @property
 @brief  商家名称
 */
@property (nonatomic, copy) NSString * merchantName;

/**
 @property
 @brief sessionType 会话类型   0表示客服会话， 1表示询单会话
 */
@property (nonatomic, assign) int sessionType;

/**
 @property
 @brief 颜色
 */
@property (nonatomic, copy) NSString *goodColor;

/**
 @property
 @brief 价格
 */
@property (nonatomic, copy) NSString *goodPrice;

/**
 @property
 @brief 图片
 */
@property (nonatomic, copy) NSString *goodPic;

/**
 @property
 @brief 头像地址
 */
@property (nonatomic, copy) NSString *iconUrl;


/**
 @property
 @brief 头像本地地址
 */
@property (nonatomic, copy) NSString *iconLocalUrl;
/**
 会员编码
 **/
@property (nonatomic, copy) NSString *memberNo;
@end
