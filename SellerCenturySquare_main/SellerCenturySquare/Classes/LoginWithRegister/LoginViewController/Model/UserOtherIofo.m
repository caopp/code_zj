//
//  UserOtherIofo.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/24.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "UserOtherIofo.h"
#import "NSString+Hashing.h"
#import "MHImageDownloadManager.h"
#import "DownloadLogControl.h"
#import "ChatManager.h"
#import "DeviceDBHelper.h"
@implementation UserOtherIofo
-(void)assignmentPhoneNumber:(NSString *)phoneNumber password:(NSString *)password
{
    if (phoneNumber == nil) {
        return;
    }
    if (password == nil) {
        return;
    }
    
    // 根据登录账户,初始化下载器
    [MHImageDownloadManager sharedInstance];
    
    [[DownloadLogControl sharedInstance] loadStateFromPlist];
    
   
    
    //聊天登录
    [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_1", phoneNumber] passWord:[[password MD5Hash] lowercaseString]];
    //打开聊天数据库
    [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_1", phoneNumber]];
    
}
@end
