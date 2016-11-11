/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ECSession.h"
#import "ECMessage.h"
#import "IMGoodsInfoDTO.h"

@interface IMMsgDBAccess : NSObject

+ (IMMsgDBAccess *)sharedInstance;
- (void)openDatabaseWithUserName:(NSString *)userName;

#pragma mark 会话操作API
//获取所有会话列表
- (NSMutableDictionary *)loadAllSessions;
//获取所有未读的会话列表
- (NSMutableDictionary *)loadAllUnReadSessions;
//获取某个商家的所有的会话列表
- (NSMutableDictionary *)loadMerchantSessions:(NSString *)merchantName;
//更新会话
- (BOOL)updateSession:(ECSession *)session;
//插入非重复  会话表
- (BOOL)insertSessionNoRepate:(ECSession*)session;
//删除某个会话
- (BOOL)deleteSession:(NSString *)goodNo;

#pragma mark 消息操作API
//增加单条消息
- (BOOL)addMessage:(ECMessage *)message;

//删除单条消息
//-(BOOL)deleteMessage:(NSString*)msgId andSession:(NSString*)sessionId;

//删除某个会话的所有消息
-( NSInteger)deleteMessageOfSession:(NSString*)sessionId;

- (NSInteger)getUnreadMessageCountFromSession;

//获取会话的某个时间点之前的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId beforeTime:(long long)timesamp;

//获取会话的某个时间点之后的count条消息
//-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId afterTime:(long long)timesamp;

//更新某消息的状态
//-(BOOL)updateState:(ECMessageState)state ofMessageId:(NSString*)msgId andSession:(NSString*)session;

//重发，更新某消息的消息id
-(BOOL)updateMessageId:(NSString*)msdNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId andSession:(NSString*)session ;

//更新询单信息
- (BOOL)updateIMGoodsInfoDTO:(IMGoodsInfoDTO *)dto;

//查询某个询单信息
- (IMGoodsInfoDTO *)queryIMGoodsInfoDTO:(NSString *)goodNo;

//查询某个询单记录中是否有大B的信息
- (BOOL)queryIsHasMessageFromSeller:(NSString *)goodNo;
//获取某个商家号的所有的会话列表
- (ECSession *)loadMerchantSessionsNo:(NSString *)merchantNo;

#pragma mark - 插入非重复数据
- (BOOL)insertMessageNoRepate:(ECMessage*)message;
@end
