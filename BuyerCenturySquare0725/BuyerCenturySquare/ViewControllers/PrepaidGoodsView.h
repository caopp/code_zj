//
//  PrepaidGoodsView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceChangeBto.h"
@protocol PrepaidGoodsDelegate <NSObject>
/**
 *  确认充值以后需要传充值的钱数 和 等级
 *
 *  @param level 等级
 *  @param money 钱数
 *  @param no  sku对应的等级
 */
- (void)prepaidGoodsLevel:(NSNumber *)level topupMoney:(NSNumber *)money skuNo:(NSInteger )no ;

//提交预付货款信息需跳转
- (void)PrepaidGoodsJumpVCMoney:(NSNumber *)money skuNo:(NSInteger)no;

@end


/**
 *  V1-V5显示这个View
 */
@interface PrepaidGoodsView : UIView
@property (nonatomic ,assign) id<PrepaidGoodsDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame BalanceDto:(BalanceChangeBto *)Dto;

@end
