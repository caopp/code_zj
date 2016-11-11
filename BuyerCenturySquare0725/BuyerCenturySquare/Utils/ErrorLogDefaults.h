//
//  ErrorLogDefaults.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/4/9.
//  Copyright © 2016年 pactera. All rights reserved.
// !保存错误日志的

#import <Foundation/Foundation.h>

@interface ErrorLogDefaults : NSObject

//!错误日志
@property(nonatomic,strong)NSMutableArray * errorLogArray;

//!获取单单例，得到数据
+(id)shareManager;

//!保存数据到plist
-(void)errorLog_save;

//!删除已经上传的plist数据
-(void)removePlistInfo;

@end
