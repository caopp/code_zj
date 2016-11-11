//
//  SaveUserIofo.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/23.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveUserIofo : NSObject

//添加数据到plist文件
-(void)addIofoDTO:(NSMutableDictionary *)DTO;

//删除数据
-(void)deleteIofoDTO;
@end
