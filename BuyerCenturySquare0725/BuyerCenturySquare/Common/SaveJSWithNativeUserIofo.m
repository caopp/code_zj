//
//  SaveJSWithNativeUserIofo.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/26.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "SaveJSWithNativeUserIofo.h"
#import "HttpManager.h"
#import "SaveUserIofo.h"

@implementation SaveJSWithNativeUserIofo
 NSMutableDictionary *arr;
            NSString *url;

-(id)init
{
    self = [super init];
    if (self) {
        [self settingParametersBlock];
    }
    return  self;
        
}

-(void)settingParametersBlock
{
    
    arr = [NSMutableDictionary  dictionaryWithCapacity:0];
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserIofoPlist.plist"];
    
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    NSString *timeStamp = [HttpManager getTimesTamp];
    
    if (![[newDic allValues] count]) {//!单点登录的时候这个plist里面的参数移除，获取到的newDic就为空，下面的字典parameters从newDic获取参数拼接的时候会崩溃，所以这里进行判断
        
        return ;
    }
    NSMutableDictionary * parameters = [HttpManager getParameterWithTimestamp:timeStamp];
    [arr setObject:parameters[@"screenType"] forKey:@"screenType"];
    [arr setObject:parameters[@"iosVersion"] forKey:@"iosVersion"];
    [arr setObject:parameters[@"appType"] forKey:@"appType"];
    [arr setObject:parameters[@"appKey"] forKey:@"appKey"];
    [arr setObject:parameters[@"deviceSn"] forKey:@"deviceSn"];
    [arr setObject:parameters[@"appVersion"] forKey:@"appVersion"];
    [arr setObject:parameters[@"deviceType"] forKey:@"deviceType"];
    [arr setObject:newDic[@"memberNo"] forKey:@"memberNo"];
    [arr setObject:newDic[@"tokenId"] forKey:@"tokenId"];
    [arr setObject:timeStamp forKey:@"timestamp"];
    [arr setObject:parameters[@"versionNo"] forKey:@"versionNo"];
    
    
    url = [HttpManager getSignWithParameter:arr];
    //根据上面获取的键值，重新写入plist文件当中
    
    NSArray *H5paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *H5plistPath1 = [H5paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *H5filename=[H5plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    //写入文件
    [arr writeToFile:H5filename atomically:YES];
}

//删除数据
-(void)deleteUserIofoDTO
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    //删除数据
    [newDic removeAllObjects];
    //写入文件
    [newDic writeToFile:filename atomically:YES];
}
@end
