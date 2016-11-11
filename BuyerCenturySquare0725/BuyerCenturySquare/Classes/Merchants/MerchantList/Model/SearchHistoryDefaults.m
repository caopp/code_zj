//
//  SearchHistoryDefaults.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchHistoryDefaults.h"
#import "LoginDTO.h"

static SearchHistoryDefaults * manager = nil;

@implementation SearchHistoryDefaults

+(id)shareManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SearchHistoryDefaults alloc]init];
        
        
    });


    return manager;

}

-(instancetype)init{

    if (self = [super init]) {
        
        //!商家
        NSString * merchantPath = [NSString stringWithFormat:@"%@/Documents/merchantHistory.plist",NSHomeDirectory()];

        self.allUserMerchantHistoryArray = [NSMutableArray arrayWithContentsOfFile:merchantPath];
        
        if (self.allUserMerchantHistoryArray == nil) {
            
            self.allUserMerchantHistoryArray  = [NSMutableArray arrayWithCapacity:0];
        
        }
        
        
        //!商品
        NSString * goodsPath = [NSString stringWithFormat:@"%@/Documents/goodsHistory.plist",NSHomeDirectory()];
        
        self.allUserGoodsHistoryArray = [NSMutableArray arrayWithContentsOfFile:goodsPath];
        
        if (self.allUserGoodsHistoryArray == nil) {
            
            self.allUserGoodsHistoryArray  = [NSMutableArray arrayWithCapacity:0];
            
        }
        
    }


    return self;
}

//!读取历史数据
-(void)readHistoryInfo{

    DebugLog(@"开始read历史");

    self.merchantHistoryArray = nil;
    self.goodsHistoryArray = nil;
    
    //!!!商家
    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组
    for (NSMutableDictionary * userDic in self.allUserMerchantHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            DebugLog(@"read:%@", [LoginDTO sharedInstance].memberNo);
            
            
            self.merchantHistoryArray = userDic[@"historyArray"];

            
            break;
            
        }
        
        
    }
    
    if (!self.merchantHistoryArray) {
        
        self.merchantHistoryArray = [NSMutableArray arrayWithCapacity:0];
    }

    //!商品
    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组
    for (NSMutableDictionary * userDic in self.allUserGoodsHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            self.goodsHistoryArray = userDic[@"historyArray"];
            
            break;

            
        }
        
        
    }
    
    if (!self.goodsHistoryArray) {
        
        self.goodsHistoryArray = [NSMutableArray arrayWithCapacity:0];
    }

    DebugLog(@"read历史完毕");

    


}
-(void)history_Save{

    //!商家
    NSString * merchantPath = [NSString stringWithFormat:@"%@/Documents/merchantHistory.plist",NSHomeDirectory()];
    
    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组
    NSMutableDictionary * oldMerchantDic;
    
    //!找到修改的字典，并移除
    for (NSMutableDictionary * userDic in self.allUserMerchantHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            oldMerchantDic = userDic;
            
            DebugLog(@"save:%@", [LoginDTO sharedInstance].memberNo);

        }
        
    }
    
    
    if (oldMerchantDic) {
        
        [self.allUserMerchantHistoryArray removeObject:oldMerchantDic];

    }
    
    
    NSMutableDictionary * nowMerchantDic = [NSMutableDictionary dictionaryWithDictionary:@{@"memberNo" : [LoginDTO sharedInstance].memberNo,
                                   @"historyArray" :self.merchantHistoryArray}];
    
    //!将当前用户的数组添加
    [self.allUserMerchantHistoryArray addObject:nowMerchantDic];
    
    [self.allUserMerchantHistoryArray writeToFile:merchantPath atomically:YES];

    
    
    //!商品
    NSString * goodsPath = [NSString stringWithFormat:@"%@/Documents/goodsHistory.plist",NSHomeDirectory()];

    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组

    
    //!找到修改的字典，并移除
    NSMutableDictionary * oldGoodsDic;
    
    for (NSMutableDictionary * userDic in self.allUserGoodsHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            oldGoodsDic = userDic;
        
        }
        
    }
    
    if (oldGoodsDic) {
        
        [self.allUserGoodsHistoryArray removeObject:oldGoodsDic];
    }
    
    
    NSMutableDictionary * nowGoodsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"memberNo" : [LoginDTO sharedInstance].memberNo,
                                   @"historyArray" :self.goodsHistoryArray}];
    
    //!将当前用户的数组添加
    [self.allUserGoodsHistoryArray addObject:nowGoodsDic];
    
    
    [self.allUserGoodsHistoryArray writeToFile:goodsPath atomically:YES];
    
    DebugLog(@"保存完成");
    
}

//!清除商家历史搜索记录
-(void)clearMerchantSeatchHistory{

    //!商家
    NSString * merchantPath = [NSString stringWithFormat:@"%@/Documents/merchantHistory.plist",NSHomeDirectory()];
    
    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组
    NSMutableDictionary * oldMerchantDic;
    
    //!找到修改的字典，并移除
    for (NSMutableDictionary * userDic in self.allUserMerchantHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            oldMerchantDic = userDic;
            
            break;
        }
        
    }
    
    
    if (oldMerchantDic) {
        
        [self.allUserMerchantHistoryArray removeObject:oldMerchantDic];
        
    }
    
    [self.allUserMerchantHistoryArray writeToFile:merchantPath atomically:YES];

    self.merchantHistoryArray = nil;
    
}

//!清除商品历史搜索记录
-(void)clearGoodsSeatchHistory{

    //!商品
    NSString * goodsPath = [NSString stringWithFormat:@"%@/Documents/goodsHistory.plist",NSHomeDirectory()];
    
    //!数组里面以用户的merberNo为key，value是保存 历史数据 的数组
    
    
    //!找到修改的字典，并移除
    NSMutableDictionary * oldGoodsDic;
    
    for (NSMutableDictionary * userDic in self.allUserGoodsHistoryArray) {
        
        if ([LoginDTO sharedInstance].memberNo && [[LoginDTO sharedInstance].memberNo isEqualToString:userDic[@"memberNo"]]) {
            
            oldGoodsDic = userDic;
            
            break;
        }
        
    }
    
    if (oldGoodsDic) {
        
        [self.allUserGoodsHistoryArray removeObject:oldGoodsDic];
    }
    
    
    [self.allUserGoodsHistoryArray writeToFile:goodsPath atomically:YES];

    self.goodsHistoryArray = nil;


}





@end
