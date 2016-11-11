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

#import "IMMsgDBAccess.h"
#import <UIKit/UIDevice.h>
#import <CommonCrypto/CommonDigest.h>
#import "DoubleSku.h"
#import "StepListDTO.h"

@interface IMMsgDBAccess()
@property (nonatomic, strong) FMDatabase *dataBase;
@end

@implementation IMMsgDBAccess

+(IMMsgDBAccess*)sharedInstance{
    static IMMsgDBAccess* imdbmanager;
    static dispatch_once_t imdbmanageronce;
    dispatch_once(&imdbmanageronce, ^{
        imdbmanager = [[IMMsgDBAccess alloc] init];
    });
    return imdbmanager;
}

- (void)openDatabaseWithUserName:(NSString*)userName {
    if (userName.length==0) {
        return;
    }
    
    //Documents:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    //username md5
    const char *cStr = [userName UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* MD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    //数据库文件夹
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:MD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            NSLog(@"Create Database Directory Failed.");
        }
        NSLog(@"%@", documentsDirectory);
    }
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"im_demo.db"];
    NSLog(@"dbPath==%@",dbPath);
    if (self.dataBase) {
        [self.dataBase close];
        self.dataBase = nil;
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    [self.dataBase open];

    [self sessionTableCreate];
    [self IMOrderTableCreateWithSession];
}

// 判断指定表是否存在
- (BOOL)checkTableExist:(NSString *)tableName {
    BOOL result = NO;
    NSString* lowtableName = [tableName lowercaseString];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT [sql] FROM sqlite_master WHERE [type] = 'table' AND lower(name) = ?", lowtableName];
    result = [rs next];
    [rs close];
    
    return result;
}

// 创建表
- (void) createTable:(NSString*)tableName sql:(NSString *)createSql {
    
    BOOL isExist = [self.dataBase tableExists:tableName];
    if (!isExist) {
        [self.dataBase executeUpdate:createSql];
    }
}

/*
 会话表
 字段	类型	约束	备注
 goodNo     TEXT    货号 即  会话名称
 sessionId 	TEXT	会话id
 dateTime 	TEXT		显示的时间
 type 	int		与消息表msgType一样
 text 	Varchar	2048	显示的内容
 unreadCount	int		未读消息数
 merchantName Varchar 2048  商家名称
 merchantNo Varchar 2048  商家编号
 sessionType  int   会话类型
 goodColor    VarChar 32   货品颜色
 goodPrice    VarChar 2048  货品价格
 goodPic      VarChar 2048  货品图片
 */

- (void)sessionTableCreate {
    [self createTable:@"sessionlist" sql:@"CREATE table sessionlist (merchantNo TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE,goodNo TEXT , sessionId TEXT, dateTime TEXT, type INTEGER, text varchar(2048), unreadCount INTEGER, merchantName varchar(2048), sessionType INTEGER, goodColor varchar(32), goodPrice varchar(2048), goodPic varchar(2048), goodsWillNo varchar(2048),extend1 varchar(2048),extend2 varchar(2048),extend3 varchar(2048),extend4 varchar(2048),extend5 varchar(2048))"];
}

/*
 消息
 ID 	int	自增	主键
 SID	Varchar 	32	会话ID
 sender	Varchar 	32	发送者
 receiver	Varchar 	32	接收者
 dateTime	Long		入库本地时间 毫秒
 msgType	int		消息类型 0:文本 1:多媒体 2:chunk消息 (0-99聊天的消息类型 100-199系统的推送消息类型)
 text	Varchar	2048	文本
 localPath	text		本地路径
 URL	text		下载路径
 isSender int   是否是发送信息
 goodColor    Varchar 32   颜色
 goodPrice    Varchar 32   价格
 goodPic   Varchar 2048   图片地址
 goodSku   Varchar 2048   sku信息
 searchGoodNo  Varchar 2048  推介商品的goodNo
 */

- (NSString*)SessionTableName:(NSString*)sessionid{
    //username md5
    const char *cStr = [sessionid UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* SessionMD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    return [NSString stringWithFormat:@"Chat_%@", SessionMD5];
}

- (NSString*)IMMessageTableCreateWithSession:(NSString*)session {
    
    NSString *tableName = [self SessionTableName:session];
    
    [self createTable:tableName sql:[NSString stringWithFormat:@"CREATE table %@(ID INTEGER PRIMARY KEY AUTOINCREMENT, SID varchar(32), sender varchar(32), receiver varchar(32), dateTime INTEGER, type INTEGER, text TEXT, localPath TEXT, URL TEXT, isSender INTEGER, goodNo varchar(2048), goodColor varchar(32), goodPrice varchar(32), goodPic varchar(2048), goodSku varchar(2048), searchGoodNo varchar(2048), goodsWillNo varchar(2048),extend varchar(2048),extend1 varchar(2048),extend2 varchar(2048),extend3 varchar(2048),extend4 varchar(2048))", tableName]];
    return tableName;
}

//创建一个询单表
- (void)IMOrderTableCreateWithSession {
    
    [self createTable:@"IMOrderList" sql:@"CREATE table IMOrderList (goodNo TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE, merchantNo varchar(2048), cartType varchar(2048), price varchar(2048), totalQuantity INTEGER, skuList varchar(2048), merchantName varchar(2048), sessionType INTEGER, goodColor varchar(32), goodPic varchar(2048), isBuyModel INTEGER, samplePrice varchar(2048), sampleSkuNo varchar(2048), stepPriceList varchar(2048), batchNumLimit INTEGER, goodsWillNo varchar(2048),extend varchar(2048),extend1 varchar(2048),extend2 varchar(2048),extend3 varchar(2048),extend4 varchar(2048))"];
}

-(BOOL)isChatTableExist:(NSString*)sessionid {

    if (sessionid.length==0) {
        return NO;
    }
    
    return [self.dataBase tableExists:[self SessionTableName:sessionid]];
}

//更新询单信息
- (BOOL)updateIMGoodsInfoDTO:(IMGoodsInfoDTO *)dto {
    
    return [self.dataBase executeUpdate:@"INSERT INTO IMOrderList(goodNo, merchantNo, cartType, price, totalQuantity, skuList, merchantName, sessionType, goodColor, goodPic, isBuyModel, samplePrice, sampleSkuNo, stepPriceList, batchNumLimit,goodsWillNo,extend) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", dto.goodsNo, dto.merchantNo, dto.cartType, [NSString stringWithFormat:@"%.2f", [dto.price floatValue]], @([dto.totalQuantity intValue]), [self skuListToString:dto.skuList], dto.merchantName, @(dto.sessionType), dto.goodColor, dto.goodPic, @(dto.isBuyModel), [NSString stringWithFormat:@"%.2f", [dto.samplePrice floatValue]], dto.sampleSkuNo, [self stepPriceListToString:dto.stepPriceList], @([dto.batchNumLimit intValue]),dto.goodsWillNo,@""];
}

//查询某个询单信息
- (IMGoodsInfoDTO *)queryIMGoodsInfoDTO:(NSString *)merchantNo {
    
    IMGoodsInfoDTO * retrunDto = [[IMGoodsInfoDTO alloc] init];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT goodNo, merchantNo, cartType, price, totalQuantity, skuList, merchantName, sessionType, goodColor, goodPic, isBuyModel, samplePrice, sampleSkuNo, stepPriceList, batchNumLimit,goodsWillNo FROM IMOrderList WHERE merchantNo = ?", merchantNo];
    while ([rs next]) {
        NSString* goodNo = [rs stringForColumnIndex:0];
        if (goodNo.length>0) {
            int columnIndex = 0;
            retrunDto.goodsNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.merchantNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.cartType = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.price = [NSNumber numberWithFloat:[[rs stringForColumnIndex:columnIndex] floatValue]]; columnIndex++;
            retrunDto.totalQuantity = [NSNumber numberWithInt:[[rs stringForColumnIndex:columnIndex] intValue]]; columnIndex++;
            retrunDto.skuList = [self skuStringToArray:[rs stringForColumnIndex:columnIndex]]; columnIndex++;
            retrunDto.merchantName = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.sessionType = [rs intForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.goodColor = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.goodPic = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.isBuyModel = [rs intForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.samplePrice = [NSNumber numberWithFloat:[[rs stringForColumnIndex:columnIndex] floatValue]];columnIndex++;
            retrunDto.sampleSkuNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            retrunDto.stepPriceList = [self stepPriceStringToArray:[rs stringForColumnIndex:columnIndex]]; columnIndex++;
            retrunDto.batchNumLimit = [NSNumber numberWithInt:[rs intForColumnIndex:columnIndex]]; columnIndex++;
             retrunDto.goodsWillNo = [rs stringForColumnIndex:columnIndex]; columnIndex++; columnIndex++;
        }
    }
    [rs close];
    
    return retrunDto;
    
}

//查询某个询单记录中是否有大B的信息
- (BOOL)queryIsHasMessageFromSeller:(NSString *)goodNo {
    
    //查询改会话的所有聊天记录
    NSString *tableName = [self IMMessageTableCreateWithSession:goodNo];
    
    BOOL isHas = NO;
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT isSender FROM (SELECT * FROM %@)", tableName]];
    while ([rs next]) {
        
        if ([rs intForColumnIndex:0] == 0) {
            isHas = YES;
        }
    }
    
    [rs close];
    return isHas;
    
}

//将skulist转化成json字符串
- (NSString *)skuListToString:(NSMutableArray *)skulist {
    
    NSMutableArray * newSkulist = [[NSMutableArray alloc] init];
    
    for (DoubleSku * skuInfo in skulist) {
        
        NSMutableDictionary* skuDictionary = [NSMutableDictionary dictionary];
        [skuDictionary setObject:skuInfo.skuNo forKey:@"skuNo"];
        [skuDictionary setObject:skuInfo.skuName forKey:@"skuName"];
        [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.sort] forKey:@"sort"];
        [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.spotValue] forKey:@"spotQuantity"];
        [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.futureValue] forKey:@"futureQuantity"];
            
        [newSkulist addObject:skuDictionary];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newSkulist
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length]!= 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

//讲json字符串转成skuList
- (NSMutableArray *)skuStringToArray:(NSString *)skuString {

    NSError *error = nil;
    NSMutableArray * jsonObject = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:[skuString dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    NSMutableArray * newArray = [[NSMutableArray alloc] init];
    if (jsonObject != nil && error == nil){
        
        for (NSMutableDictionary * dic in jsonObject) {
            
            DoubleSku * sku = [[DoubleSku alloc] init];
            
            sku.skuNo = [dic objectForKey:@"skuNo"];
            sku.skuName = [dic objectForKey:@"skuName"];
            sku.sort = [[dic objectForKey:@"sort"] integerValue];
            sku.spotValue = [[dic objectForKey:@"spotQuantity"] integerValue];
            sku.futureValue = [[dic objectForKey:@"futureQuantity"] integerValue];
            
            [newArray addObject:sku];
        }
        
        return newArray;
        
    }else{
        return nil;
    }
}

//将阶梯价格转化成json字符串
- (NSString *)stepPriceListToString:(NSMutableArray *)stepPriceList {
    
    NSMutableArray * newStepPricelist = [[NSMutableArray alloc] init];
    
    for (StepListDTO * step in stepPriceList) {
        
        NSMutableDictionary* stepDictionary = [NSMutableDictionary dictionary];
        [stepDictionary setObject:step.price forKey:@"price"];
        [stepDictionary setObject:step.Id forKey:@"Id"];
        [stepDictionary setObject:step.minNum forKey:@"minNum"];
        [stepDictionary setObject:step.maxNum forKey:@"maxNum"];
        [stepDictionary setObject:step.sort forKey:@"sort"];
        
        [newStepPricelist addObject:stepDictionary];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newStepPricelist
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length]!= 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

//将阶梯字符串转化成stepPriceList
- (NSMutableArray *)stepPriceStringToArray:(NSString *)stepPriceString {

    NSError *error = nil;
    NSMutableArray * jsonObject = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:[stepPriceString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&error];
    
    NSMutableArray * newArray = [[NSMutableArray alloc] init];
    if (jsonObject != nil && error == nil){
        
        for (NSMutableDictionary * dic in jsonObject) {
            
            StepListDTO * step = [[StepListDTO alloc] init];
            step.price = [dic objectForKey:@"price"];
            step.Id = [dic objectForKey:@"Id"];
            step.minNum = [dic objectForKey:@"minNum"];
            step.maxNum = [dic objectForKey:@"maxNum"];
            step.sort = [dic objectForKey:@"sort"];
            
            [newArray addObject:step];
        }
        
        return newArray;
        
    }else{
        return nil;
    }
}

//更新会话表
- (BOOL)updateSession:(ECSession*)session{
    
    return [self.dataBase executeUpdate:@"INSERT INTO sessionlist(goodNo, sessionId, dateTime, type, text, unreadCount, merchantName, merchantNo, sessionType, goodColor, goodPrice, goodPic,goodsWillNo,extend1) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)", session.goodNo, session.sessionId, @(session.dateTime), @(session.type), session.text, @(session.unreadCount), session.merchantName, session.merchantNo,@(session.sessionType), session.goodColor, session.goodPrice, session.goodPic,session.goodsWillNo,session.iconUrl];
}
//插入非重复  会话表
- (BOOL)insertSessionNoRepate:(ECSession*)session{
    NSString *strExist = [NSString stringWithFormat:@"select COUNT(*) from sessionlist where merchantNo= '%@'",session.merchantNo];
    int count = [self.dataBase intForQuery:strExist];
    if (count) {
        return NO;
    }else{
        NSString *str = [NSString stringWithFormat:@"INSERT INTO sessionlist( merchantName, merchantNo,extend1) VALUES ('%@','%@','%@')",session.merchantName, session.merchantNo,session.iconUrl];
        return [self.dataBase executeUpdate:str];
    }
    
           // @"INSERT INTO sessionlist( merchantName, merchantNo,extend1) VALUES (%@,%@,%@)",session.merchantName, session.merchantNo,session.iconUrl];
}
//删除某个会话
- (BOOL)deleteSession:(NSString *)merchantNo {
    
    return [self.dataBase executeUpdate:@"DELETE FROM sessionlist WHERE merchantNo = ?",merchantNo];
}


- (NSMutableDictionary *)loadAllSessions {
    
    NSMutableDictionary * sessionDictionay = [NSMutableDictionary dictionary];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT goodNo, sessionId, dateTime, type, text, unreadCount, merchantName, merchantNo, sessionType, goodColor, goodPrice, goodPic ,goodsWillNo,extend1 FROM sessionlist ORDER BY dateTime DESC"];
    while ([rs next]) {
        NSString* merchantNo = [rs stringForColumnIndex:7];
        if (merchantNo.length>0) {
            ECSession* session = [[ECSession alloc] init];
            int columnIndex = 0;
           
            session.goodNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.merchantName = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.merchantNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionType = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.goodColor = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPrice = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPic = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            
            session.goodsWillNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.iconUrl = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            [sessionDictionay setObject:session forKey:session.merchantNo];
             NSLog(@"%@-----%@",session.merchantNo,session.merchantName);
        }
    }
    [rs close];
    
    return sessionDictionay;
}

- (NSMutableDictionary *)loadAllUnReadSessions {
    
    NSMutableDictionary * sessionDictionay = [NSMutableDictionary dictionary];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT goodNo, sessionId, dateTime, type, text, unreadCount, merchantName, merchantNo, sessionType, goodColor, goodPrice, goodPic,goodsWillNo,extend1  FROM sessionlist WHERE unreadCount > 0 ORDER BY dateTime DESC"];
    while ([rs next]) {
        NSString* merchantNo = [rs stringForColumnIndex:7];
        if (merchantNo.length>0) {
            ECSession* session = [[ECSession alloc] init];
            int columnIndex = 0;
            session.goodNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.merchantName = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.merchantNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionType = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.goodColor = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPrice = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPic = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodsWillNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.iconUrl = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            [sessionDictionay setObject:session forKey:session.merchantNo];
        }
    }
    [rs close];
    
    return sessionDictionay;
}
//获取某个商家号的所有的会话列表
- (ECSession *)loadMerchantSessionsNo:(NSString *)merchantNo {
    
     ECSession * session = [[ECSession alloc] init];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT goodNo, sessionId, dateTime, type, text, unreadCount, merchantName, merchantNo, sessionType, goodColor, goodPrice, goodPic,goodsWillNo,extend1 FROM sessionlist WHERE merchantNo = ?", merchantNo];
    while ([rs next]) {
        NSString* merchantNo = [rs stringForColumnIndex:7];
        if (merchantNo.length>0) {
            int columnIndex = 0;
            session.goodNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.merchantName = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.merchantNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionType = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.goodColor = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPrice = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPic = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodsWillNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.iconUrl = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        }
    }
    [rs close];
    
    return session;
}

//获取某个商家的所有的会话列表
- (NSMutableDictionary *)loadMerchantSessions:(NSString *)merchantName {
    
    NSMutableDictionary * sessionDictionay = [NSMutableDictionary dictionary];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT goodNo, sessionId, dateTime, type, text, unreadCount, merchantName, merchantNo, sessionType, goodColor, goodPrice, goodPic,goodsWillNo,extend1 FROM sessionlist WHERE merchantName = ?", merchantName];
    while ([rs next]) {
        NSString* merchantNo = [rs stringForColumnIndex:7];
        if (merchantNo.length>0) {
            ECSession* session = [[ECSession alloc] init];
            int columnIndex = 0;
            session.goodNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.merchantName = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.merchantNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.sessionType = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.goodColor = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPrice = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodPic = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.goodsWillNo = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.iconUrl = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            [sessionDictionay setObject:session forKey:session.merchantNo];
        }
    }
    [rs close];
    
    return sessionDictionay;
}

-(NSString*)getDateTime:(long long) data {
    return [NSString stringWithFormat:@"%lld",data];
}

-(BOOL)getGroupFlag:(NSString *)msgid {
    if ([msgid hasPrefix:@"g"]) {
        return YES;
    } else {
        return NO;
    }
}

-(long long)getDateInt:(NSString*) date {
    return [date longLongValue];
}

-(NSString*)getMessageMediaType:(NSString*)displayName {
    if ([displayName hasSuffix:@".amr"]) {
        return @"[语音]";
    } else if ([displayName hasSuffix:@".jpg"] || [displayName hasSuffix:@".png"]) {
        return @"[图片]";
    } else if ([displayName hasSuffix:@".mp4"]) {
        return @"[视频]";
    } else {
        return @"[文件]";
    }
}

//-(int)setValueDic:(NSMutableDictionary *)valueDic andMediaMsgBody:(ECMessageBody*) msgBody andIndex:(int) index {
//    
//    if ([msgBody isKindOfClass:[ECTextMessageBody class]]) {
//        
//        [valueDic setObject:@(MessageBodyType_Text) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
//        ECTextMessageBody * msg = (ECTextMessageBody*) msgBody;
//        
//        if (msg.text) {
//            [valueDic setObject:msg.text forKey:[NSString stringWithFormat:@"%d", index]];
//        }index++;
//        
//        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
//        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
//        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
//        
//    } else if ([msgBody isKindOfClass:[ECFileMessageBody class]]) {
//        
//        [valueDic setObject:@(msgBody.messageBodyType) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
//        ECFileMessageBody * msg = (ECFileMessageBody*) msgBody;
//        
//        NSString *file = @"[文件]";
//        if (msg.localPath.length > 0) {
//            file = [self getMessageMediaType:msg.localPath];
//            
//        } else if (msg.remotePath.length > 0) {
//            file = [self getMessageMediaType:msg.remotePath];
//        }
//        
//        if (file) {
//            [valueDic setObject:file forKey:[NSString stringWithFormat:@"%d", index]];
//        }index++;
//        
//        if (msg.localPath) {
//            [valueDic setObject:msg.localPath forKey:[NSString stringWithFormat:@"%d", index]];
//        }index++;
//        
//        if (msg.remotePath) {
//            [valueDic setObject:msg.remotePath forKey:[NSString stringWithFormat:@"%d", index]];
//        }index++;
//        
//        if (msg.serverTime) {
//            [valueDic setObject:msg.serverTime forKey:[NSString stringWithFormat:@"%d", index]];
//        }index++;
//        
//        if ([msgBody isKindOfClass:[ECImageMessageBody class]]) {
//            ECImageMessageBody * imagemsg = (ECImageMessageBody*) msgBody;
//            if (imagemsg.thumbnailLocalPath) {
//                [valueDic setObject:imagemsg.thumbnailRemotePath forKey:[NSString stringWithFormat:@"%d", index]];
//            }
//        }
//
//        index++;
//    }
//    
//    return index;
//}

#pragma mark - 插入非重复数据
- (BOOL)insertMessageNoRepate:(ECMessage*)message{
    NSString *tableName = [self IMMessageTableCreateWithSession:message.merchantNo];

    NSString *strExist = [NSString stringWithFormat:@"select COUNT(*) from %@ where extend= '%@'",tableName,message.messageId];
    int count = [self.dataBase intForQuery:strExist];
    if (count) {
        return YES;
    }else {
        BOOL bo = [self addMessage:message];
        return bo;
    }
}

//增加单条消息
- (BOOL)addMessage:(ECMessage *)message {
    
    if (message.merchantNo.length==0) {
        return NO;
    }
   //根据 商家编码创建表名
    NSString *tableName = [self IMMessageTableCreateWithSession:message.merchantNo];
    
    BOOL ret = NO;
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"1",[NSNull null],@"2",[NSNull null],@"3",[NSNull null],@"4",[NSNull null],@"5",[NSNull null],@"6",[NSNull null],@"7",[NSNull null],@"8",[NSNull null],@"9", [NSNull null],@"10", [NSNull null],@"11", [NSNull null],@"12",[NSNull null], @"13", [NSNull null], @"14",[NSNull null], @"15",[NSNull null], @"16",[NSNull null], @"17",[NSNull null], @"18",nil];
    int index = 1;
    
    if (message.SID) {
        [valueDic setObject:message.SID forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.sender) {
        [valueDic setObject:message.sender forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.receiver) {
        [valueDic setObject:message.receiver forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.dateTime) {
        [valueDic setObject:@(message.dateTime) forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    [valueDic setObject:@(message.type) forKey:[NSString stringWithFormat:@"%d", index]];
    index++;
    
    if (message.text) {
        [valueDic setObject:message.text forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.localPath) {
        [valueDic setObject:message.localPath forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.URL) {
        [valueDic setObject:message.URL forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    [valueDic setObject:@(message.isSender) forKey:[NSString stringWithFormat:@"%d", index]];
    index++;
    
    [valueDic setObject:message.goodNo forKey:[NSString stringWithFormat:@"%d", index]];
    index++;

    
    if (message.type == 0 || message.type == 1) {
        if (message.messageId) {
            [valueDic setObject:message.messageId forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        ret = [self.dataBase executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(SID, sender, receiver, dateTime, type, text, localPath, URL, isSender, goodNo,extend) VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11)", tableName] withParameterDictionary:valueDic];
    }else {
        
        if (message.type == 4) {
            
            if (message.goodColor) {
                [valueDic setObject:message.goodColor forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodPrice) {
                [valueDic setObject:message.goodPrice forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodPic) {
                [valueDic setObject:message.goodPic forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodSku) {
                [valueDic setObject:message.goodSku forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.searchGoodNo) {
                [valueDic setObject:message.searchGoodNo forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            if (message.goodsWillNo) {
                [valueDic setObject:message.goodsWillNo forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            if (message.messageId) {
                [valueDic setObject:message.messageId forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            ret = [self.dataBase executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(SID, sender, receiver, dateTime, type, text, localPath, URL, isSender, goodNo, goodColor, goodPrice, goodPic, goodSku,searchGoodNo,goodsWillNo,extend) VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17)", tableName] withParameterDictionary:valueDic];
            
        }else {
            
            if (message.goodColor) {
                [valueDic setObject:message.goodColor forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodPrice) {
                [valueDic setObject:message.goodPrice forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodPic) {
                [valueDic setObject:message.goodPic forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            
            if (message.goodSku) {
                [valueDic setObject:message.goodSku forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            if (message.goodsWillNo) {
                [valueDic setObject:message.goodsWillNo forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            if (message.messageId) {
                [valueDic setObject:message.messageId forKey:[NSString stringWithFormat:@"%d", index]];
            }index++;
            ret = [self.dataBase executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(SID, sender, receiver, dateTime, type, text, localPath, URL, isSender, goodNo, goodColor, goodPrice, goodPic, goodSku,goodsWillNo,extend) VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16)", tableName] withParameterDictionary:valueDic];
        }
    }
    
    return ret;
}

- (NSString*)getUserName:(NSString*)userId {
    NSString *stringname = nil;
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT nickName FROM userName WHERE userid=?", userId];
    if ([rs next]) {
        stringname = [rs stringForColumnIndex:0];
    }
    [rs close];
    
    return stringname;
}

//删除单条消息
-(BOOL)deleteMessage:(NSString*)msgId andSession:(NSString*)sessionId{
    
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat: @"DELETE FROM %@ WHERE msgid = '%@'",[self SessionTableName:sessionId], msgId]];
    }
    return NO;
}

//删除某个会话的所有消息
-(NSInteger)deleteMessageOfSession:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat:@"DELETE FROM %@",[self SessionTableName:sessionId]]];
    }
    return 0;
}

- (BOOL)deleteWithTable:(NSString*)table {
    return [self runSql:[NSString stringWithFormat:@"DELETE FROM %@",table]];
}

- (BOOL)deleteAllSession {
    return [self deleteWithTable:@"session"];
}

- (BOOL)deleteAllGroupNotice {
    return [self deleteWithTable:@"im_groupnotice"];
}

- (BOOL)runSql:(NSString*)sql {
    return [self.dataBase executeUpdate:sql];
}

- (int)getCountWithSql:(NSString*)sql {
    
    int count = 0;
    FMResultSet *rs = [self.dataBase executeQuery:sql];
    if ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    return count;
}

-(NSInteger)getUnreadMessageCountFromSession {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT sum(unreadCount) FROM session"]];
}

-(NSArray*)getSomeMessagesCount:(NSInteger)count andConditions:(NSString*) conditions OfSession:(NSString *)sessionId {
    
    NSString *tableName = [self IMMessageTableCreateWithSession:sessionId];
    
    NSMutableArray * msgArray = [NSMutableArray array];
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT SID, sender, receiver, dateTime, type, text, localPath, URL, isSender, goodNo, goodColor, goodPrice, goodPic, goodSku, searchGoodNo ,goodsWillNo FROM (SELECT * FROM %@ WHERE %@  ORDER BY dateTime DESC LIMIT %d) ORDER BY dateTime ASC", tableName, conditions, (int)count]];
   
    while ([rs next]) {
        ECMessage* msg = [[ECMessage alloc] init];
        int columnIndex = 0;
        msg.SID = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.sender = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.receiver = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
        msg.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
        msg.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.localPath = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.URL = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.isSender = [rs intForColumnIndex:columnIndex];columnIndex++;
        msg.goodNo = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.goodColor = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.goodPrice = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.goodPic = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.goodSku = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.searchGoodNo = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.goodsWillNo = [rs stringForColumnIndex:columnIndex];columnIndex++;
        
        [msgArray addObject:msg];
    }
    [rs close];
    return msgArray;
}

//获取会话的某个时间点之前的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId beforeTime:(long long)timesamp {
    return [self getSomeMessagesCount:count andConditions:[NSString stringWithFormat:@"dateTime <= %lld ",timesamp] OfSession:sessionId];
}

////获取会话的某个时间点之后的count条消息
//-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId afterTime:(long long)timesamp {
//    return [self getSomeMessagesCount:count andConditions:[NSString stringWithFormat:@"createdTime >= %lld ",timesamp] OfSession:sessionId];
//}


//-(id)getMessageBodyWithResultSet:(FMResultSet*)rs andType:(MessageBodyType)type {
//    
//    switch (type) {
//            
//        case MessageBodyType_Text: {
//            ECTextMessageBody* messageBody = [[ECTextMessageBody alloc] initWithText:[rs stringForColumnIndex:8]];
//            messageBody.serverTime = [rs stringForColumnIndex:11];
//            return messageBody;
//        }
//            
//        case MessageBodyType_File: {
//            ECFileMessageBody * messageBody = [[ECFileMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
//            messageBody.remotePath = [rs stringForColumnIndex:10];
//            messageBody.serverTime = [rs stringForColumnIndex:11];
//            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
//            return messageBody;
//        }
//            
//        case MessageBodyType_Image: {
//            ECImageMessageBody * messageBody = [[ECImageMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
//            messageBody.remotePath = [rs stringForColumnIndex:10];
//            messageBody.serverTime = [rs stringForColumnIndex:11];
//            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
//            messageBody.thumbnailRemotePath = [rs stringForColumnIndex:13];
//            return messageBody;
//        }
//            
//        case MessageBodyType_Video: {
//            ECVideoMessageBody * messageBody = [[ECVideoMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
//            messageBody.remotePath = [rs stringForColumnIndex:10];
//            messageBody.serverTime = [rs stringForColumnIndex:11];
//            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
//            return messageBody;
//        }
//            
//        case MessageBodyType_Voice: {
//            ECVoiceMessageBody * messageBody = [[ECVoiceMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
//            messageBody.remotePath = [rs stringForColumnIndex:10];
//            messageBody.serverTime = [rs stringForColumnIndex:11];
//            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
//            return messageBody;
//        }
//            
//        default:
//            return nil;
//    }
//}
//
////更新某消息的状态
//-(BOOL)updateState:(ECMessageState)state ofMessageId:(NSString*)msgId andSession:(NSString*)sessionId {
//    if ([self isChatTableExist:sessionId]) {
//    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET state = %d WHERE msgid = '%@' ",[self SessionTableName:sessionId],(int)state, msgId]];
//    }
//    return NO;
//}

//重发，更新某消息的消息id
-(BOOL)updateMessageId:(NSString*)msdNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId andSession:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET msgid='%@', createdTime=%lld WHERE msgid='%@' ", [self SessionTableName:sessionId], msdNewId, time, msgOldId]];
    }
    return NO;
}

//-(BOOL)updateMessageStateFailedAndSessionId:(NSString*)sessionId {
//    if ([self isChatTableExist:sessionId]) {
//    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET state=%d WHERE state=%d ", [self SessionTableName:sessionId],(int)ECMessageState_SendFail, (int)ECMessageState_Sending]];
//    }
//    return NO;
//}

@end
