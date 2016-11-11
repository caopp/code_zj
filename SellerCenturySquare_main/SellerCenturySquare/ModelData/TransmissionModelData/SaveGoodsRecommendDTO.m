//
//  SaveGoodsRecommendDTO.m
//  SellerCenturySquare
//
//  Created by zhoujian on 15/10/30.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "SaveGoodsRecommendDTO.h"

@implementation SaveGoodsRecommendDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberChatList = [[NSArray alloc]init];
        
        return self;
    }else{
        return nil;
    }
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberChatList"]]) {
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                
                NSArray *list = [dictInfo objectForKey:@"memberChatList"];
                
                for (NSDictionary *dic in list) {
                    
                    MemberChatDTO *memberChatDTO = [[MemberChatDTO alloc]init];
                    [memberChatDTO setDictFrom:dic];
                    
                    [array addObject:memberChatDTO];
                }
                
                self.memberChatList = array;
                
            }
       
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

@implementation MemberChatDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                
                NSArray *list = [dictInfo objectForKey:@"goodsList"];
                
                for (NSDictionary *dic in list) {
                    
                    GoodsDTO *goodsDTO = [[GoodsDTO alloc]init];
                    [goodsDTO setDictFrom:dic];
                    
                    [array addObject:goodsDTO];
                }
                
                self.goodsList = array;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberChatAccount"]]) {
                
                self.memberChatAccount = [dictInfo objectForKey:@"memberChatAccount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberChantName"]]) {
                
                self.memberChantName = [dictInfo objectForKey:@"memberChantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if([self.memberChantName length]==11&& [self.memberChantName hasPrefix:@"1"]){
                NSString *nickAccount = [self.memberChantName  stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                self.memberChantName = nickAccount;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

@implementation GoodsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                
                self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"smallPicUrl"]]) {
                
                self.smallPicUrl = [dictInfo objectForKey:@"smallPicUrl"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end