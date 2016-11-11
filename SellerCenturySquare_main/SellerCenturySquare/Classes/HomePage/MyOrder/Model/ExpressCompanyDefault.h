//
//  ExpressCompanyDefault.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
// !快递公司单例

#import <Foundation/Foundation.h>

@interface ExpressCompanyDefault : NSObject

//!快递公司数组
@property(nonatomic,strong)NSMutableArray * compayDataArray;

//!快递公司首字母集合
@property(nonatomic,strong)NSMutableArray * firstTitleDataArray;

//!获取单单例，得到数据
+(id)shareManager;

//!保存数据
-(void)Data_Save;

@end
