//
//  CityPropValueDefault.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/5/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CityPropValueDefault.h"

static CityPropValueDefault *manager = nil;

@interface CityPropValueDefault ()

@end

@implementation CityPropValueDefault

//采用单利
+(id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CityPropValueDefault alloc]init];
    });
    return manager;
}
//进行数据版本控制
-(void)dataPropValueControl
{
    //进行数据请求
    [HttpManager sendHttpRequestForJudgeWheterGetNewExpressListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
            //对当前版本进行控制
            NSString * propValue = dic[@"data"][0][@"propValue"];
            //版本
            NSString * savedPropValue =[MyUserDefault defaultLoadAppSetting_cityVersion];
            
            //进行版本比较
            if (![savedPropValue isEqualToString:propValue]) {
                //不相同
                [self requestCityDataPropValue:propValue];
            }
               
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
#pragma mark =====省市区数据进行请求====
-(void)requestCityDataPropValue:(NSString *)propValue
{
    
    [HttpManager sendHttpRequestForGetAreaListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@""]) {
            
            //数据进行储存
            if (_cityArr == nil) {
                _cityArr = [NSMutableArray arrayWithCapacity:0];
            }

            _cityArr = [dic[@"data"][@"list"] copy];
            
        
            //进行版本保存
            [MyUserDefault defaultSaveAppSetting_cityVersion:propValue];
            
            //根据上面获取的键值，重新写入plist文件当中
            NSString * companyPath = [NSString stringWithFormat:@"%@/Documents/allCity.plist",NSHomeDirectory()];
            
            [_cityArr writeToFile:companyPath atomically:YES];
         
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

@end
