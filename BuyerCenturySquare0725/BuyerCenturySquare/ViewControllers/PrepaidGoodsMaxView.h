//
//  PrepaidGoodsMaxView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceChangeBto.h"
/**
 *  V6显示这个View
 */

@protocol PrepaidGoodsMaxDelegate <NSObject>
//确认充值以后需要传充值的钱数
- (void)prepaidGoodsMaxMoney:(NSNumber *)money skuNO:(NSInteger )no;

//提交预付货款信息需跳转
- (void)PrepaidGoodsMaxJumpVC:(NSNumber *)money skuNo:(NSInteger)no;


@end

@interface PrepaidGoodsMaxView : UIView
@property (nonatomic ,strong)BalanceChangeBto *balanceBto;
@property (nonatomic ,strong) NSString *level;
@property (nonatomic ,assign)id<PrepaidGoodsMaxDelegate>delegate;


@end
