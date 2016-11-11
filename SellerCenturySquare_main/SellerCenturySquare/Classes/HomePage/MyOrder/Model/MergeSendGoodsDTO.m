//
//  MergeSendGoodsDTO.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MergeSendGoodsDTO.h"

@implementation MergeSendGoodsDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self &&dictInfo) {
        @try {
            
            if ([self checkLegitimacyForData:dictInfo[@"memberList"]]) {
                self.memberListArr = [NSMutableArray array];
                NSArray *membArr = dictInfo[@"memberList"];
                if (membArr.count>0) {

                    for (NSDictionary *dict in membArr) {
                        MemberListDTO *memberDto = [[MemberListDTO alloc] init];
                        [memberDto setDictFrom:dict];
                        [self.memberListArr addObject:memberDto];
                        
                    }
                }
                
            }
            
            
            if ([self checkLegitimacyForData:dictInfo[@"totalCount"]]) {
                self.totalCount = dictInfo[@"totalCount"];
                
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}
@end


@implementation MemberListDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self &&dictInfo) {
        @try {
            if ([self checkLegitimacyForData:dictInfo[@"memberNo"]]) {
                self.memberNo = dictInfo[@"memberNo"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"nickName"]]) {
                self.nickName = dictInfo[@"nickName"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"memberPhone"]]) {
                self.mobilePhone = dictInfo[@"memberPhone"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"chatAccount"]]) {
                self.chatAccount = dictInfo[@"chatAccount"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"orderList"]]) {
               NSArray *listArr = dictInfo[@"orderList"];
                if (listArr.count > 0) {
                    self.orderList = [NSMutableArray array];
                    self.groupList = [NSMutableArray array];
                    
                    for (int i = 0;i<listArr.count;i++) {
                        NSDictionary *dictArr = listArr[i];
                        
                        NSArray *listDcit = dictArr [@"orderGoodsItems"];
                        
                        NSMutableArray *arr = [NSMutableArray array];
                        
                        for (int j = 0; j<listDcit.count; j++) {
                            
                            NSDictionary *dict = listDcit[j];
                            
//                        for (NSDictionary *dict in listDcit) {
                            OrderListDTO *orderList = [[OrderListDTO alloc] init];
                            [orderList setDictFrom:dict];
                            [orderList setDictDetailInfo:dictArr];
                            
                          
                            if (j == 0) {
                                orderList.numb =@"first";
                            }
                            if (j == (listDcit.count-1)) {
                                orderList.numb = @"last";
                            }
                            if (j == 0&&j == (listDcit.count-1)) {
                                orderList.numb = @"own";
                            }
                            
                            [self.orderList addObject:orderList];
                            
                            NSString *orderCode = dictArr[@"orderCode"];
                            if ([orderCode isEqualToString:orderList.orderCode]) {
                                [arr addObject:orderList];
                            }
                        }
                        [self.groupList addObject:arr];

                    }
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}


@end


@implementation OrderListDTO
- (void)setDictDetailInfo:(NSDictionary *)dictDetailInfo
{
    if (self &&dictDetailInfo) {
        @try {
            
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"addressId"]]) {
                
                self.addressId = [dictDetailInfo objectForKey:@"addressId"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictDetailInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictDetailInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictDetailInfo objectForKey:@"memberName"];
            }
            
            
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictDetailInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"memberPhone"]]) {
                
                self.memberPhone = [dictDetailInfo objectForKey:@"memberPhone"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictDetailInfo objectForKey:@"orderCode"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"status"]]) {
                
                self.status = [dictDetailInfo objectForKey:@"status"];
            }
//            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"quantity"]]) {
//                
//                self.quantity = [dictDetailInfo objectForKey:@"quantity"];
//            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"originalTotalAmount"]]) {
                
                self.originalTotalAmount = [dictDetailInfo objectForKey:@"originalTotalAmount"];
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictDetailInfo objectForKey:@"totalAmount"];
            }
            
            if ([self checkLegitimacyForData:dictDetailInfo[@"paidTotalAmount"]]) {
                self.paidTotalAmount = dictDetailInfo[@"paidTotalAmount"];
                
            }
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"type"]]) {
                
                self.type = [dictDetailInfo objectForKey:@"type"];
            }
            
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"chatAccount"]]) {
                
                self.chatAccount = [dictDetailInfo objectForKey:@"chatAccount"];
            }
            
            if ([self checkLegitimacyForData:[dictDetailInfo objectForKey:@"quantity"]]) {
                
                self.totalQuantity = [dictDetailInfo objectForKey:@"quantity"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self &&dictInfo) {
        @try {
            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
                
                self.cartType = [dictInfo objectForKey:@"cartType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sizes"]]) {
                
                self.sizes = [dictInfo objectForKey:@"sizes"];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}



@end

