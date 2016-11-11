//
//  DeviceDBHelper.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMsgDBAccess.h"
#import "XMPPFramework.h"

#define KNotification_DeleteLocalSessionMessage @"KNotification_DeleteLocalSessionMessage"

@interface DeviceDBHelper : NSObject
@property (nonatomic, strong) NSArray* joinGroupArray;
@property (nonatomic, strong) NSMutableDictionary *sessionDic;
@property (nonatomic, strong) NSString * currentGoodNo;
@property(nonatomic, strong) NSString *name;
//获取句柄
+(DeviceDBHelper*)sharedInstance;

//获取会话中最新消息100条
-(NSArray *)getLatestHundredMessageOfSessionId:(NSString *)sessionId andSize:(NSInteger)pageSize;

- (NSArray *)getMessageOfSessionId:(NSString *)sessionId beforeTime:(long long)timetamp andPageSize:(NSInteger)pageSize;

//删除会话的数据
-(void)deleteAllMessageOfSession:(NSString *)sessionId;

//从表中删除某个会话
- (BOOL)deleteOneSessionOfSession:(ECSession *)session;

//清空某个会话的未读条数
- (BOOL)clearOneSessionUnReadCount:(ECSession *)session;

- (NSArray*)getMyCustomSession;

//获取所有会话列表排序
- (NSMutableDictionary *)getAllSession;

//获取有未读信息的会话列表
- (NSArray *)getUnReadSession;

//-(void)updateMessageId:(ECMessage*)msgNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId;

//打开数据库
-(void)openDataBasePath:(NSString*)userName;

-(void)markMessagesAsReadOfSession:(NSString*)sessionId;

//-(void)deleteMessage:(ECMessage*)messageId andPre:(ECMessage*)message;

- (void)addNewMessage:(XMPPMessage *)message withIsSender:(int)isSender;

- (NSString *)insertMessage:(XMPPMessage *)message withIsSender:(int)isSender withAddSession:(BOOL)isSession;

- (ECMessage *)messageConvertToECMessage:(XMPPMessage *)message withIsSender:(int)isSender;
-(NSString *)statusWith:(int)status;
-(NSString *)typeWith:(int)type;
//0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
-(NSString *)refundStatusWith:(int)refundStatus;
@end
