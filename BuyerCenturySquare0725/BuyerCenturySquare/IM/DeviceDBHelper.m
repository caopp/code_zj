//
//  DeviceDBHelper.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#define DefaultThumImageHigth 90.0f
#define DefaultPressImageHigth 960.0f

#import "DeviceDBHelper.h"
#import "ECSession.h"
#import "ECMessage.h"
#import "CSPUtils.h"
#import "CommonTools.h"
#import "ChatManager.h"
#import "LoginDTO.h"
@implementation DeviceDBHelper

+(DeviceDBHelper*)sharedInstance{
    
    static dispatch_once_t DeviceDBHelperonce;
    static DeviceDBHelper * DeviceDBHelperstatic;
    dispatch_once(&DeviceDBHelperonce, ^{
        DeviceDBHelperstatic = [[DeviceDBHelper alloc] init];
    });
    return DeviceDBHelperstatic;
}

-(void)openDataBasePath:(NSString*)userName{
    [[IMMsgDBAccess sharedInstance] openDatabaseWithUserName:userName];
    self.sessionDic = nil;
    [self getMyCustomSession];
}

-(NSArray*)getLatestHundredMessageOfSessionId:(NSString*)sessionId andSize:(NSInteger)pageSize {
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    
    return [[IMMsgDBAccess sharedInstance] getSomeMessagesCount:pageSize OfSession:sessionId beforeTime:(long long)tmp];
}

-(NSArray*)getMessageOfSessionId:(NSString *)sessionId beforeTime:(long long)timetamp andPageSize:(NSInteger)pageSize {
    return [[IMMsgDBAccess sharedInstance] getSomeMessagesCount:pageSize OfSession:sessionId beforeTime:timetamp];
}

//删除会话的数据
-(void)deleteAllMessageOfSession:(NSString*)sessionId{
    [self.sessionDic removeObjectForKey:sessionId];
    [[IMMsgDBAccess sharedInstance] deleteSession:sessionId];
    [[IMMsgDBAccess sharedInstance] deleteMessageOfSession:sessionId];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_DeleteLocalSessionMessage object:sessionId];
}

- (BOOL)deleteOneSessionOfSession:(ECSession *)session  {
    
    [self.sessionDic removeObjectForKey:session.merchantNo];
    return [[IMMsgDBAccess sharedInstance] deleteSession:session.goodNo];
}

- (BOOL)clearOneSessionUnReadCount:(ECSession *)session {
    
    
    ECSession *newsession = [self.sessionDic objectForKey:session.merchantNo];

    newsession.unreadCount = 0;
    
    if (session) {
        session.unreadCount = 0;
        
        return [[IMMsgDBAccess sharedInstance] updateSession:session];
    }else{
        return [[IMMsgDBAccess sharedInstance] updateSession:newsession];
    }
    
}

//-(void)updateMessageId:(ECMessage*)msgNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId{
//    ECSession *session = [self.sessionDic objectForKey:msgNewId.sessionId];
//    if (session) {
//        session.dateTime = time;
//    }
//    [[IMMsgDBAccess sharedInstance] updateSession:session];
//    [[IMMsgDBAccess sharedInstance] updateMessageId:msgNewId.messageId andTime:time ofMessageId:msgOldId andSession:msgNewId.sessionId];
//}

-(void)markMessagesAsReadOfSession:(NSString*)sessionId{
    ECSession *session = [self.sessionDic objectForKey:sessionId];
    if (session) {
        session.unreadCount = 0;
        [[IMMsgDBAccess sharedInstance] updateSession:session];
    }
}

//-(void)deleteMessage:(ECMessage*)message andPre:(ECMessage*)premessage{
//    if (premessage) {
//        long long int time = [premessage.timestamp longLongValue];
//        ECSession * session = [self messageConvertToSession:premessage];
//        session.dateTime = time;
//        [[IMMsgDBAccess sharedInstance] updateSession:session];
//    } else {
//        [self.sessionDic removeObjectForKey:message.sessionId];
//        [[IMMsgDBAccess sharedInstance] deleteSession:message.sessionId];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
//    [[IMMsgDBAccess sharedInstance] deleteMessage:message.messageId andSession:message.sessionId];
//}

//-(void)insertHistoryData:(NSArray *)arr{
//    [[IMMsgDBAccess sharedInstance] inser];
//    insertSessionNoRepate
//}

- (void)addNewMessage:(XMPPMessage *)message withIsSender:(int)isSender{
    
    ECSession * session = [self messageConvertToSession:message withIsSender:isSender];
    ECMessage * ecMessage = [self messageConvertToECMessage:message withIsSender:isSender];
    if (![ecMessage.messageId length]) {
        ecMessage.messageId = [self generateUUID];
    }


    if ([session.merchantNo isEqualToString: _currentGoodNo]||isSender ==1) {
        session.unreadCount = 0;
    }else{
        session.unreadCount++;
    }
    
   BOOL bo =  [[IMMsgDBAccess sharedInstance] updateSession:session];
    NSLog(@"bo====%d",bo);
    
    if (ecMessage.isSender == 0 && ecMessage.type == 1) {
        
        //异步加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:ecMessage.URL]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            ecMessage.localPath = [self saveToDocument:image];
            
            [[IMMsgDBAccess sharedInstance] addMessage:ecMessage];
        });
    }else {
        [[IMMsgDBAccess sharedInstance] addMessage:ecMessage];
    }
}

- (void)insertMessage:(XMPPMessage *)message withIsSender:(int)isSender withAddSession:(BOOL)isSession{
    if (isSession) {
        ECSession * session = [self messageConvertToSession:message withIsSender:isSender];

        [[IMMsgDBAccess sharedInstance] updateSession:session];

    }
    
    ECMessage * ecMessage = [self messageConvertToECMessage:message withIsSender:isSender];
    if (![ecMessage.messageId length]) {
        ecMessage.messageId = [self generateUUID];
    }

    NSString *to = [NSString stringWithFormat:@"%@_0", [MyUserDefault defaultLoadAppSetting_loginPhone]];

    if ([ecMessage.receiver isEqualToString:to]) {
        ecMessage.isSender = 0;
    }else{
        ecMessage.isSender = 1;
    }
   
    
    if (ecMessage.isSender == 0 && ecMessage.type == 1) {
        
        //异步加载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:ecMessage.URL]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            ecMessage.localPath = [self saveToDocument:image];
            
            [[IMMsgDBAccess sharedInstance] insertMessageNoRepate:ecMessage];
        });
    }else {
        [[IMMsgDBAccess sharedInstance] insertMessageNoRepate:ecMessage];
    }
}


-(NSString*)saveToDocument:(UIImage*)image {
    
    UIImage* fixImage = [self fixOrientation:image];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString* fileName =[NSString stringWithFormat:@"%@.jpg", [formater stringFromDate:[NSDate date]]];
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //图片按0.5的质量压缩－》转换为NSData
    CGSize pressSize = CGSizeMake((DefaultPressImageHigth/fixImage.size.height) * fixImage.size.width, DefaultPressImageHigth);
    UIImage * pressImage = [CommonTools compressImage:fixImage withSize:pressSize];
    NSData *imageData = UIImageJPEGRepresentation(pressImage, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    
    CGSize thumsize = CGSizeMake((DefaultThumImageHigth/fixImage.size.height) * fixImage.size.width, DefaultThumImageHigth);
    UIImage * thumImage = [CommonTools compressImage:fixImage withSize:thumsize];
    NSData * photo = UIImageJPEGRepresentation(thumImage, 0.5);
    NSString * thumfilePath = [NSString stringWithFormat:@"%@.jpg_thum", filePath];
    [photo writeToFile:thumfilePath atomically:YES];
    
    return filePath;
    
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage), 0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:              CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);              break;
    }       // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取会话列表
- (NSArray*)getMyCustomSession {

    self.sessionDic = nil;
    
    if (!self.sessionDic){
        self.sessionDic = [[IMMsgDBAccess sharedInstance] loadAllSessions];
    }
    
    return  [self.sessionDic.allValues sortedArrayUsingComparator:
                ^(ECSession *obj1, ECSession* obj2){
                    if(obj1.dateTime > obj2.dateTime) {
                        return(NSComparisonResult)NSOrderedAscending;
                    }else {
                        return(NSComparisonResult)NSOrderedDescending;
                    }
            }];
}

//获取所有的会话列表
- (NSMutableDictionary *)getAllSession {
    
    NSMutableDictionary * dic = [[IMMsgDBAccess sharedInstance] loadAllSessions];
    
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] init];
    
    NSArray * keysArray = dic.allKeys;
    
    for (int i = 0; i < keysArray.count; i++) {
        
        ECSession * session = (ECSession *)[dic objectForKey:[keysArray objectAtIndex:i]];
        //判断是否包含这个商家的信息
        if ([newDic.allKeys indexOfObject:session.merchantName] == NSNotFound) {
            
            NSMutableArray * newArray = [[NSMutableArray alloc] initWithObjects:session, nil];
            
            [newDic setObject:newArray forKey:session.merchantName];
            
        }else {
            
            NSMutableArray * newArray = (NSMutableArray *)[newDic objectForKey:session.merchantName];
            
            [newArray addObject:session];
            
            [newDic setObject:newArray forKey:session.merchantName];
        }
    }
    
    return newDic;
}

//获取所有未读信息的列表
- (NSArray *)getUnReadSession {
    
    NSMutableDictionary * dic = [[IMMsgDBAccess sharedInstance] loadAllUnReadSessions];
    
    return [dic.allValues sortedArrayUsingComparator:
            ^(ECSession *obj1, ECSession* obj2){
                if(obj1.dateTime > obj2.dateTime) {
                    return(NSComparisonResult)NSOrderedAscending;
                }else {
                    return(NSComparisonResult)NSOrderedDescending;
                }
            }];
}

//消息中心获取会话列表
- (NSArray *)getCenterSession {

    NSMutableDictionary * dic = [[IMMsgDBAccess sharedInstance] loadAllSessions];
    
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] init];
    
    NSArray * keysArray = dic.allKeys;
    
    //先将取出的会话数组进行分组
    for (int i = 0; i < keysArray.count; i++) {
        
        ECSession * session = (ECSession *)[dic objectForKey:[keysArray objectAtIndex:i]];
        //判断是否包含这个商家的信息
        if ([newDic.allKeys indexOfObject:session.merchantName] == NSNotFound) {
            
            NSMutableArray * newArray = [[NSMutableArray alloc] initWithObjects:session, nil];
            
            [newDic setObject:newArray forKey:session.merchantName];
            
        }else {
            
            NSMutableArray * newArray = (NSMutableArray *)[newDic objectForKey:session.merchantName];
            
            [newArray addObject:session];
            
            [newDic setObject:newArray forKey:session.merchantName];
        }
    }

    //每一组进行筛选
    NSArray * newKeysArray = newDic.allKeys;
    
    for(int i = 0; i < newKeysArray.count; i++){
        
        //取出每一个数组数据
        NSMutableArray * array = (NSMutableArray *)[newDic objectForKey:[newKeysArray objectAtIndex:i]];
        
        //先进行时间排序
        NSArray * sortarray = [array sortedArrayUsingComparator:
                           ^(ECSession *obj1, ECSession* obj2){
                               if(obj1.dateTime > obj2.dateTime) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }];
        
        NSMutableArray * musortArray = [[NSMutableArray alloc] initWithArray:sortarray];
        
        //先讲客服放在第一个
        for (ECSession * session in musortArray) {
            if (session.sessionType == 0) {
                
                [musortArray removeObject:session];
                [musortArray insertObject:session atIndex:0];
                break;
            }
        }

        //如果会话数量大于3个则要去除不必要的会话
        if (musortArray.count > 3) {
            
            for (int i = (int)(musortArray.count - 1); i > 2; i--) {
                ECSession *session = (ECSession *)[musortArray objectAtIndex:i];
                if (session.unreadCount == 0) {
                    
                    [musortArray removeObject:session];
                }
            }
        }
        
        [newDic setObject:musortArray forKey:[newKeysArray objectAtIndex:i]];
    }
    
    return [newDic.allValues sortedArrayUsingComparator:
                ^(NSMutableArray *obj1, NSMutableArray* obj2){
                              
                    ECSession * session1 = (ECSession *)[obj1 objectAtIndex:0];
                    ECSession * session2 = (ECSession *)[obj2 objectAtIndex:0];
                              
                    if(session1.dateTime > session2.dateTime) {
                        return(NSComparisonResult)NSOrderedAscending;
                    }else {
                        return(NSComparisonResult)NSOrderedDescending;
                    }
            }];
    
}

//获取某个商城所有的会话列表
- (NSArray *)getMerchantSession:(NSString *)merchantName {
    
    NSMutableDictionary * dic = [[IMMsgDBAccess sharedInstance] loadMerchantSessions:merchantName];
    
    NSArray * array = [dic.allValues sortedArrayUsingComparator:
                       ^(ECSession *obj1, ECSession* obj2){
                           if(obj1.dateTime > obj2.dateTime) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    NSMutableArray * newArray = [[NSMutableArray alloc] initWithArray:array];
    
    //进行排序
    for (ECSession * session in newArray) {
        if (session.sessionType == 0) {
            
            [newArray removeObject:session];
            [newArray insertObject:session atIndex:0];
            break;
        }
    }
    
    return newArray;
}

//讲XMPPMessage转化成ECSession
- (ECSession *)messageConvertToSession:(XMPPMessage *)message withIsSender:(int)isSender{
    
    ECSession *session = [self.sessionDic objectForKey:[[message elementForName:@"merchantNo"] stringValue]];
    if (session == nil) {
        session = [[ECSession alloc] init];
    }
    
    session.goodNo = [[message elementForName:@"goodNo"] stringValue];
    
    if (isSender == 0) {
        session.sessionId = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }else {
        session.sessionId = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
    
    session.dateTime = [CSPUtils getTimeStamp:[[message elementForName:@"messageTime"] stringValue]];
    session.type = [[[message elementForName:@"bodyType"] stringValue] intValue];
    switch (session.type){
        case 0:{
            session.text = [[message elementForName:@"body"] stringValue];
        }
            break;
        case 1:
            session.text = @"[图片]";
            break;
        case 2:
            session.text = @"[询单信息]";
            break;
        case 3:
            session.text = @"[发版询单信息]";
            break;
        case 4:
            session.text = @"[商品推荐]";
            break;
        case 5:{
           NSString *strSku = [[message elementForName:@"goodSku"] stringValue];
            
            NSData *jsonData = [strSku dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            if (!jsonData) {
                session.text = @"";
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
             NSString *orderState = [dic objectForKey:@"orderState"];
            NSString *orderPrice = [dic objectForKey:@"orderPrice"];
            NSString *orderStatus = [dic objectForKey:@"orderStatus"];
            NSNumber *refundStatus = [dic objectForKey:@"refundStatus"];
            NSString *status = [refundStatus isKindOfClass:[NSNumber class]]?[[DeviceDBHelper sharedInstance] refundStatusWith:[refundStatus intValue]]:[[DeviceDBHelper sharedInstance] statusWith:[orderStatus intValue] ];
             session.text = [NSString stringWithFormat:@"[采购单] %@ %@ ￥%@ ",[self typeWith:[orderState intValue]],status,orderPrice];
        }
            break;
    }
    session.merchantNo = [[message elementForName:@"merchantNo"] stringValue];
    if (isSender == 0) {
        session.iconUrl = [[message elementForName:@"iconUrl"] stringValue];
        session.merchantName = [[message elementForName:@"merchantName"] stringValue];
    }else {
        if ([session.iconUrl length]) {
        }else{
            ECSession *eCSession = [[IMMsgDBAccess sharedInstance] loadMerchantSessionsNo:session.merchantNo];
            session.iconUrl = eCSession.iconUrl;
        }
        session.merchantName = [[message elementForName:@"merchantName"] stringValue];
    }
    //session.iconUrl = [[message elementForName:@"iconUrl"] stringValue];
    session.goodsWillNo =  [[message elementForName:@"goodsWillNo"] stringValue];
    
    session.goodColor = [[message elementForName:@"goodColor"] stringValue];
    session.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
    session.goodPic = [[message elementForName:@"goodPic"] stringValue];
    session.sessionType = [[[message elementForName:@"sessionType"] stringValue] intValue];
    [self.sessionDic setObject:session forKey:session.merchantNo];
    return session;
}

//讲XMPPMessage转化成ECMessage
- (ECMessage *)messageConvertToECMessage:(XMPPMessage *)message withIsSender:(int)isSender{
    
    ECMessage * ecMessage = [[ECMessage alloc] init];
    ecMessage.messageId = [[message attributeForName:@"id"] stringValue];
    ecMessage.merchantNo = [[message elementForName:@"merchantNo"] stringValue];
    ecMessage.goodNo = [[message elementForName:@"goodNo"] stringValue];

    if (isSender == 0) {
        ecMessage.SID = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
        
    }else {
        ecMessage.SID = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
    
    ecMessage.sender = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    ecMessage.receiver = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    ecMessage.dateTime = [CSPUtils getTimeStamp:[[message elementForName:@"messageTime"] stringValue]];
    ecMessage.type = [[[message elementForName:@"bodyType"] stringValue] intValue];
    
    if (ecMessage.type == 1) {
        if (isSender == 0) {
            ecMessage.URL = [[message elementForName:@"Url"] stringValue];
        }else {
            ecMessage.localPath = [[message elementForName:@"picLocalUrl"] stringValue];
            ecMessage.URL = [[message elementForName:@"Url"] stringValue];
        }
    }
    ecMessage.goodsWillNo =  [[message elementForName:@"goodsWillNo"] stringValue];
    ecMessage.isSender = isSender;
    switch (ecMessage.type){
        case 0:{
            ecMessage.text = [[message elementForName:@"body"] stringValue];
        }
            break;
        case 1:
            ecMessage.text = @"[图片]";
            break;
        case 2:
            ecMessage.text = @"[询单信息]";
            ecMessage.goodColor = [[message elementForName:@"goodColor"] stringValue];
            ecMessage.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
            ecMessage.goodPic = [[message elementForName:@"goodPic"] stringValue];
            ecMessage.goodSku = [[message elementForName:@"goodSku"] stringValue];
            break;
        case 3:
            ecMessage.text = @"[发版询单信息]";
            ecMessage.goodColor = [[message elementForName:@"goodColor"] stringValue];
            ecMessage.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
            ecMessage.goodPic = [[message elementForName:@"goodPic"] stringValue];
            break;
        case 4:
            ecMessage.text = @"[商品推荐]";
            ecMessage.goodColor = [[message elementForName:@"goodColor"] stringValue];
            ecMessage.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
            ecMessage.goodPic = [[message elementForName:@"goodPic"] stringValue];
            ecMessage.searchGoodNo = [[message elementForName:@"searchGoodNo"] stringValue];
            break;
        case 5:
            ecMessage.text = @"[采购单信息]";
            ecMessage.goodColor = [[message elementForName:@"goodColor"] stringValue];
            ecMessage.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
            ecMessage.goodPic = [[message elementForName:@"goodPic"] stringValue];
            ecMessage.goodSku = [[message elementForName:@"goodSku"] stringValue];
            break;
    }
    
    return ecMessage;
}
-(NSString *)statusWith:(int)status{
    switch (status) {
        case 0:
            return @"采购单取消";
            break;
        case 1:
            return @"待付款";
            break;
        case 2:
            return @"待发货";
            break;
        case 3:
            return @"待收货";
            break;
        case 4:
            return @"交易取消";
            break;
        case 5:
            return @"交易完成";
            break;
            
        default:
            return nil;
            break;
    }
}
-(NSString *)typeWith:(int)type{
    if (type ==0) {
        return @"期货单";
    }else{
        return @"现货单";
    }
}
//0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
-(NSString *)refundStatusWith:(int)refundStatus{
    switch (refundStatus) {
        case 0:
            return @"退货退款_处理中";
            break;
        case 1:
            return @"退货退款_处理完成";
            break;
        case 2:
            return @"仅退款_处理中";
            break;
        case 3:
            return @"仅退款_处理完成";
            break;
        case 4:
            return @"换货_处理中";
            break;
        case 5:
            return @"换货_处理完成";
            break;
        case 6:
            return @"已取消";
            break;
        default:
            return nil;
            break;
    }
}
-(NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        
        CFRelease(uuid);
    }
    
    return result;
}

@end
