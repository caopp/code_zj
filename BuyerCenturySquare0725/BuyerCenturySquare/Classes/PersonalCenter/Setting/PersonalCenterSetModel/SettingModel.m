//
//  SettingModel.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

-(void)setShowMoneyPage:(void (^)(NSString *str))str
{
    [HttpManager sendHttpRequestForSwitchsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //0开启、1关闭
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if (str) {
                str(dic[@"data"][@"registFlag"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

@end
