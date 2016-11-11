//
//  SaveGoodsRecommendDTO.h
//  SellerCenturySquare
//
//  Created by zhoujian on 15/10/30.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SaveGoodsRecommendDTO : BasicDTO

//商家聊天帐号数组
@property(nonatomic,strong)NSArray* memberChatList;



@end

@interface MemberChatDTO : BasicDTO
//商品信息数组
@property(nonatomic,strong)NSArray* goodsList;
//商家聊天帐号
@property(nonatomic,copy)NSString* memberChatAccount;
@property(nonatomic,copy)NSString *memberChantName;
@property(nonatomic,copy)NSString *memberNo;
@end

@interface GoodsDTO : BasicDTO

@property(nonatomic,copy)NSString* goodsNo;
@property(nonatomic,copy)NSString* goodsWillNo;
@property(nonatomic,copy)NSString* color;
@property(nonatomic,copy)NSString* price;
@property(nonatomic,copy)NSString* smallPicUrl;

@end