//
//  ECMessage.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/9/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMessage : NSObject

@property(nonatomic,copy)NSString *messageId;
/**
 @property
 @brief 主键。自增
 */
@property (nonatomic, assign) int ID;

/**
 @property
 @brief 会话ID
 */
@property (nonatomic, copy) NSString *SID;

@property(nonatomic,copy)NSString *memberNo;

/**
 @property
 @brief 发送者
 */
@property (nonatomic, copy) NSString *sender;

/**
 @property
 @brief 接受者
 */
@property (nonatomic, copy) NSString *receiver;

/**
 @property
 @brief 创建时间 显示的时间 毫秒
 */
@property (nonatomic, assign) long long dateTime;

/**
 @property
 @brief 与消息表msgType一样
 */
@property (nonatomic, assign) int type;

/**
 @property
 @brief 显示的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 @property
 @brief 本地路径
 */
@property (nonatomic, copy) NSString *localPath;

/**
 @property
 @brief 下载地址
 */
@property (nonatomic, copy) NSString *URL;

/**
 @property
 @brief 商品编号
 */
@property (nonatomic, copy) NSString *goodNo;

@property(nonatomic, copy) NSString *goodsWillNo;
/**
 @property
 @brief 是否是发送信息  0表示的是接受信息 1表示的是发送信息
 */
@property (nonatomic, assign) int isSender;

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
 @brief 图片地址
 */
@property (nonatomic, copy) NSString *goodPic;

/**
 @property
 @brief sku
 */
@property (nonatomic, copy) NSString *goodSku;

@property (nonatomic, copy) NSString *searchGoodNo;
/**
 显示时间
 */
@property (nonatomic,assign)BOOL showTime;
@end
