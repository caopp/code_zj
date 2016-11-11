//
//  SearchHistoryDefaults.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistoryDefaults : NSObject

//!根据用户no保存的
@property(nonatomic,strong)NSMutableArray * allUserMerchantHistoryArray;

@property(nonatomic,strong)NSMutableArray * allUserGoodsHistoryArray;



//!商家历史搜索
@property(nonatomic,strong)NSMutableArray * merchantHistoryArray;

//!商品历史搜索
@property(nonatomic,strong)NSMutableArray * goodsHistoryArray;

//!获取单单例，得到数据
+(id)shareManager;

//!读取历史数据
-(void)readHistoryInfo;

//!保存数据到plist
-(void)history_Save;


//!清除商家历史搜索记录
-(void)clearMerchantSeatchHistory;

//!清除商品历史搜索记录
-(void)clearGoodsSeatchHistory;



@end
