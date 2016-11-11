//
//  ChatManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
//#import "HttpManager.h"

//!测试 5222
//#define IPAddress @"116.31.82.98"

//!上线 5222
//#define IPAddress @"218.97.53.34"

//!IP测试
//#define  IPAddress @"114.112.81.218"

//首都在线域名
#define IPAddress @"mim.zjsj1492.com"

////首都在线域名 上线
//#define IPAddress @"im.zjsj1492.com"

//!上线、测试
#define Port 5222

//!开发
//#define Port 5223




#define DelayMessage @"DelayMessage"
#define ReceiveDelayMessage @"ReceiveDelayMessage"
#define ReceiveMessage @"receiveMessage"

#import <Foundation/Foundation.h>
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "ConversationWindowViewController.h"
#import "ShopGoodsDTO.h"

@interface ChatManager : NSObject

@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) NSString * xmppUserName;
@property (nonatomic, strong) NSString * xmppPassWord;
@property (nonatomic, strong)NSString *memberNo;
@property (nonatomic, strong)NSString *iconUrl;
@property(nonatomic,strong)NSTimer *timer ;
@property(nonatomic,assign)long long timesever;
+ (instancetype)shareInstance;

//用于连接服务器
- (BOOL)connectToServer:(NSString *)userName passWord:(NSString *)passWord;

//配置xmppStream
- (void)setupStream;

//发送离线信息
- (BOOL)disconnectToServer;

//基本的文本信息
- (void)SendTextMessage:(NSString *)textMessage toUserID:(NSString *)userID withECSession:(ECSession *)session withMerchantname:(NSString *)name;

//图片信息
- (void)SendPicMessage:(NSString *)picUrl toUserID:(NSString *)userID withECSession:(ECSession *)session withMerchantname:(NSString *)name withLocalUrl:(NSString *)localUrl;

//商品推介，发送cell信息
- (void)SendGoodMessage:(ShopGoodsDTO *)dto toUserID:(NSString *)userID withIMtype:(NSString *)imtype withMerchantname:(NSString *)name withECSession:(ECSession *)session;
//采购单发送
- (void)SendOrderListMessage:(NSDictionary *)dicOrder toUserID:(NSString *)userID  withMerchantname:(NSString *)name;
//用于封装商品信息成xmppmessage
- (NSXMLElement *)packageGoodsInfo:(ShopGoodsDTO *)dto toUserID:(NSString *)userID withIMtype:(NSString *)imtype withMerchantname:(NSString *)name withECSession:(ECSession *)session;
//封装成数组采购单
- (NSXMLElement *)packageOrderGoodsInfoWithDic:(NSDictionary *)dicOrder withName:(NSString *)name withType:(NSString *)type toUserID:(NSString *)userID;
-(BOOL)retunisXmppConnected;

-(void)testGetChatHistory:(NSString *)userID;
// 获取客服账号
-(void)getServerAcount:(NSString *)memberNo withName:(NSString *)name withController:(UIViewController *)controller;

-(void)getServerAcountWithName:(NSString *)name  withMerchanNo:(NSString *)merchanNo withOrderDic:(NSDictionary *)dic withController:(UIViewController *)controller;
//本地维护时间
-(void)openTime:(long)time;
-(void)closeTime;
@end
