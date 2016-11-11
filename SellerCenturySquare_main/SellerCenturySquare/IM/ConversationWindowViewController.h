//
//  ConversationWindowViewController.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#define BigBOrSmallB @"BigB"
#define messagePageSize 20

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ECSession.h"
@interface ConversationWindowViewController : BaseViewController

@property (strong, nonatomic) NSString * receiver;

@property (strong, nonatomic) ECSession * currentECSession;

@property (strong, nonatomic) NSString * histrorySearchKey;

@property(strong,nonatomic)NSNumber *timeStart;
/*
 * 从会话进入的初始化方法 参数ECSession
 * 用于从会话进入的聊天
 */
- (instancetype)initWithSession:(ECSession *)session;

/*
 * 普通的客服会话
 * 用于从客服进入的聊天
 */
- (instancetype)initWithName:(NSString *)name withJID:(NSString *)jid  withMemberNo:(NSString *)_memberNo;
/*
 * 普通的客服会话
 * 用于从客服进入的聊天,但界面显示问题调整
 */
- (instancetype)initWithNameWithYOffsent:(NSString *)name withJID:(NSString *)jid withMemberNO:(NSString*)_memberNO;
- (instancetype)initWithNameWithYOffsent:(NSString *)name withJID:(NSString *)jid;
//采购单
- (instancetype)initOrderWithName:(NSString *)name jid:(NSString *)receiverJid withMerchanNo:(NSString *)merchantNo withDic:(NSDictionary *)dtoDic;
@end
