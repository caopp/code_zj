//
//  UserOtherInfo.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/24.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "UserOtherInfo.h"
#import "MHImageDownloadManager.h"
#import "DownloadLogControl.h"
#import "ChatManager.h"
#import "DeviceDBHelper.h"
#import "NSString+Hashing.h"
@implementation UserOtherInfo

-(void)assignmentPhoneNumber:(NSString *)phoneNumber password:(NSString *)password
{
    if (password == nil) {
        return;
    }
    if (phoneNumber == nil) {
        return;
    }

    [MHImageDownloadManager sharedInstance];
    [[DownloadLogControl sharedInstance] loadStateFromPlist];
    
    
    //获取会员信息
    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //聊天登录
    //聊天登录
    [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_0", phoneNumber] passWord:[[password MD5Hash] lowercaseString]];
    
    //打开聊天数据库
    [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_0", phoneNumber]];
    
    
    
    
    
    
}
@end
