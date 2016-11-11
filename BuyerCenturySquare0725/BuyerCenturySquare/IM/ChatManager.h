//
//  ChatManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//#define IPAddress @"183.61.244.243"


//!测试 5222  开发环境 5223
//#define IPAddress @"116.31.82.98"

//!上线 5222
//#define IPAddress @"218.97.53.34"

//!首都在线
//#define  IPAddress @"114.112.81.218"

////首都在线域名--测试
#define IPAddress @"mim.zjsj1492.com"

////首都在线域名--上线
//#define IPAddress @"im.zjsj1492.com"

//!测试、上线
#define Port 5222

//!开发
//#define Port 5223


#define DelayMessage @"DelayMessage"
#define ReceiveDelayMessage @"ReceiveDelayMessage"
#define ReceiveMessage @"receiveMessage"

#import <Foundation/Foundation.h>
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "IMGoodsInfoDTO.h"
#import "OrderGoodsItemDTO.h"
#import "OrderAllListDTO.h"
@interface ChatManager : NSObject

@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString * xmppUserName;
@property (nonatomic, strong) NSString * xmppPassWord;
@property (nonatomic, weak)  NSArray *arrDto;
@property(nonatomic,strong)NSTimer *timer ;
@property(nonatomic,assign)long long timesever;
//用于连接服务器
- (BOOL)connectToServer:(NSString *)userName passWord:(NSString *)passWord;

//配置xmppStream
- (void)setupStream;

//发送离线信息
- (BOOL)disconnectToServer;

//基本的文本信息
- (void)SendTextMessage:(NSString *)textMessage toUserID:(NSString *)userID withGoodsDTO:(IMGoodsInfoDTO *)dto;

//发送图片信息
- (void)SendPicMessage:(NSString *)picUrl toUserID:(NSString *)userID withGoodsDTO:(IMGoodsInfoDTO *)dto withLocalUrl:(NSString *)localUrl;

//商品询单查询，发送采购单cell信息
- (void)SendOrderMessage:(IMGoodsInfoDTO *)dto toUserID:(NSString *)userID;
//采购单发送
- (void)SendOrderListMessage:(NSDictionary *)dicOrder toUserID:(NSString *)userID ;
//发版询单查询，发送采购单cell信息
- (void)SendModelOrderMessage:(IMGoodsInfoDTO *)dto toUserID:(NSString *)userID;

//商品推介，发送cell信息
- (void)SendGoodMessage:(IMGoodsInfoDTO *)dto toUserID:(NSString *)userID;

//用于封装商品信息成xmppmessage
- (NSXMLElement *)packageGoodsInfo:(IMGoodsInfoDTO *)dto withType:(NSString *)type toUserID:(NSString *)userID;
- (NSXMLElement *)packageGoodsInfoArray:(NSArray *)arrGoodsInfo withType:(NSString *)type toUserID:(NSString *)userID;
//封装成数组采购单
- (NSXMLElement *)packageOrderGoodsInfoWithDic:(NSDictionary *)dicOrder withType:(NSString *)type toUserID:(NSString *)userID ;
-(BOOL)retunisXmppConnected;//oppenfire 链接状态

//本地维护时间
-(void)openTime:(long)time;
-(void)closeTime;
@end
