
//  SaveUserIofo.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/23.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "SaveUserIofo.h"
#import "MyUserDefault.h"
@implementation SaveUserIofo

/*
 注意：此方法更新和写入是共用的
 */
//写入数据到plist文件
-(void)addIofoDTO:(NSMutableDictionary *)DTO
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserIofoPlist.plist"];
    //写入文件
    [DTO writeToFile:filename atomically:YES];
    
}


//删除数据
-(void)deleteIofoDTO{
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserIofoPlist.plist"];
    
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    //删除数据
    [newDic removeAllObjects];
    //写入文件
    [newDic writeToFile:filename atomically:YES];
    
}



@end
