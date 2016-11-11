//
//  ConversationWindowViewController.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#define BigBOrSmallB @"SmallB"
#define messagePageSize 20

#import <UIKit/UIKit.h>
#import "IMGoodsInfoDTO.h"
#import "ECSession.h"
#import "BaseViewController.h"

//聊天的类型
typedef enum {
    
    IMType_Service = 0,       //客户会话
    IMType_Order = 1          //询单会话

} IMType;

@interface ConversationWindowViewController : BaseViewController

@property (strong, nonatomic) NSString * receiver;

@property (strong, nonatomic) NSString * merchantno;

@property (assign, nonatomic) IMType imType;

@property (strong, nonatomic) IMGoodsInfoDTO * imGoodsInfoDTO;

@property (strong, nonatomic) ECSession * currentSession;

@property (assign, nonatomic) BOOL isSendOrder;//询单
@property (assign, nonatomic) BOOL isSendOrderList;//采购单
@property (strong, nonatomic) NSString * histrorySearchKey;
@property (assign,nonatomic)     BOOL isWaite;//是否显示等待 

@property(strong,nonatomic)NSNumber *timeStart;
//询单初始化方法  参数，聊天人名称，聊天人JId, 聊天界面的类型
- (instancetype)initWithName:(NSString *)name jid:(NSString *)receiverJid withGood:(IMGoodsInfoDTO *)dto;

- (instancetype)initWithName:(NSString *)name jid:(NSString *)receiverJid withArray:(NSArray *)dtoArr;
//客服聊天初始化方法
- (instancetype)initServiceWithName:(NSString *)name jid:(NSString *)receiverJid withMerchantNo:(NSString *)merchantNo;
- (instancetype)initServiceWithName:(NSString *)name jid:(NSString *)receiverJid;
//会话初始化方法
- (instancetype)initWithSession:(ECSession *)session;
- (instancetype)initOrderWithName:(NSString *)name jid:(NSString *)receiverJid withMerchanNo:(NSString *)merchantNo withDic:(NSDictionary *)dtoDic;
@end
