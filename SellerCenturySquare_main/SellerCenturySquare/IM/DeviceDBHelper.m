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
    
    [self.sessionDic removeObjectForKey:session.sessionId];
    return [[IMMsgDBAccess sharedInstance] deleteSession:session.sessionId];
}

- (BOOL)clearOneSessionUnReadCount:(ECSession *)session {

    ECSession *newsession = [self.sessionDic objectForKey:session.sessionId];
    newsession.unreadCount = 0;
    
    session.unreadCount = 0;
    return [[IMMsgDBAccess sharedInstance] updateSession:session];
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

- (void)addNewMessage:(XMPPMessage *)message withIsSender:(int)isSender{
    
    ECSession * session = [self messageConvertToSession:message withIsSender:isSender];
    ECMessage * ecMessage = [self messageConvertToECMessage:message withIsSender:isSender];
    if (![ecMessage.messageId length]) {
        ecMessage.messageId = [self generateUUID];
    }

    if ([session.goodNo isEqualToString: _currentGoodNo]||isSender) {
        session.unreadCount = 0;
    }else{
        session.unreadCount++;
    }
    
    BOOL bo_session =  [[IMMsgDBAccess sharedInstance] updateSession:session];
    
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
- (NSString *)insertMessage:(XMPPMessage *)message withIsSender:(int)isSender withAddSession:(BOOL)isSession{
  
    
    ECMessage * ecMessage = [self messageConvertToECMessage:message withIsSender:isSender];
    if (![ecMessage.messageId length]) {
        ecMessage.messageId = [self generateUUID];
    }
    
    NSString *to = [NSString stringWithFormat:@"%@_1", [LoginDTO sharedInstance].merchantAccount];
    
    if ([ecMessage.receiver isEqualToString:to]) {
        ecMessage.isSender = 0;
        isSender = NO;
    }else{
        ecMessage.isSender = 1;
        isSender = YES;
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
    if (isSession) {
        ECSession * session = [self messageConvertToSession:message withIsSender:isSender];
        
        [[IMMsgDBAccess sharedInstance] updateSession:session];
        return session.jid;
    }
    return nil;
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

//讲XMPPMessage转化成ECSession
- (ECSession *)messageConvertToSession:(XMPPMessage *)message withIsSender:(int)isSender{
    
    NSString * jid;
   
    if (isSender == 0) {
        jid = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }else {
        jid = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }

   NSString *sessionId = [[message elementForName:@"memberNo"] stringValue];

    ECSession *session = [self.sessionDic objectForKey:sessionId];
    if (session == nil) {
        session = [[ECSession alloc] init];
    }
    NSString *goodNo =[[message attributeForName:@"goodNo"] stringValue];
    session.goodNo = goodNo?goodNo:@"";
    session.sessionId = sessionId;
    session.jid = jid;
  
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
        case 5:
        {
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
    if (isSender == 0) {
        session.merchantName = [[message elementForName:@"fromName"] stringValue];
        session.iconUrl = [[message elementForName:@"iconUrl"] stringValue];

    }else {
        if ([session.iconUrl length]) {
        }else{
            ECSession *eCSession = [[IMMsgDBAccess sharedInstance] querySession:sessionId];
            session.iconUrl = eCSession.iconUrl;
        }
       
        session.merchantName = [[message elementForName:@"fromName"] stringValue];
    }
    
    session.goodColor = [[message elementForName:@"goodColor"] stringValue];
    session.goodPrice = [[message elementForName:@"goodPrice"] stringValue];
    session.goodPic = [[message elementForName:@"goodPic"] stringValue];
    session.sessionType = [[[message elementForName:@"sessionType"] stringValue] intValue];
    session.goodsWillNo = [[message elementForName:@"goodsWillNo"] stringValue];
    session.memberNo = [[message elementForName:@"memberNo"] stringValue];
    [self.sessionDic setObject:session forKey:session.sessionId];
    return session;
}

//讲XMPPMessage转化成ECMessage
- (ECMessage *)messageConvertToECMessage:(XMPPMessage *)message withIsSender:(int)isSender{
    
    ECMessage * ecMessage = [[ECMessage alloc] init];
    
//    if( [[[message elementForName:@"sessionType"] stringValue] intValue] == 1){
//        
//        if (isSender == 0) {
//            
//            ecMessage.goodNo = [[[message elementForName:@"goodNo"] stringValue] stringByAppendingString:[NSString stringWithFormat:@"_%@",[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0]]];
//        }else {
//            
//            ecMessage.goodNo = [[[message elementForName:@"goodNo"] stringValue] stringByAppendingString:[NSString stringWithFormat:@"_%@",[[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0]]];
//        }
//    }else {
//        
        ecMessage.goodNo = [[message elementForName:@"goodNo"] stringValue]?[[message elementForName:@"goodNo"] stringValue]:@"";
   // }
    ecMessage.memberNo = [[message elementForName:@"memberNo"] stringValue];
    ecMessage.messageId = [[message attributeForName:@"id"] stringValue];
    if (isSender == 0) {
        ecMessage.SID = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
        ecMessage.sender = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
        ecMessage.receiver = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];
    }else {
        
        ecMessage.SID = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];;
        ecMessage.sender = [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];;
        ecMessage.receiver = [[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0];;
    }
    
    ecMessage.dateTime = [CSPUtils getTimeStamp:[[message elementForName:@"messageTime"] stringValue]];
    ecMessage.type = [[[message elementForName:@"bodyType"] stringValue] intValue];
    ecMessage.goodsWillNo = [[message elementForName:@"goodsWillNo"] stringValue];
    ecMessage.isSender = isSender;
    
    if (ecMessage.type == 1) {
        if (isSender == 0) {
            ecMessage.URL = [[message elementForName:@"Url"] stringValue];
        }else {
            ecMessage.localPath = [[message elementForName:@"picLocalUrl"] stringValue];
            ecMessage.URL = [[message elementForName:@"Url"] stringValue];
        }
    }
    
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
