//
//  BankAndOhterPayView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankAndOhterPayDelegate <NSObject>
//直接到银行转账
- (void)bankAndOhterPayJumpVC;
/**
 *  支付宝或微信支付
 */
- (void)bankAndOhterPayMethodPayment:(NSString *)method;

@end

@interface BankAndOhterPayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *confirmPayBtn;


@property (nonatomic ,strong) NSString *payType;
//支付金额
@property (nonatomic ,strong) NSNumber *payMoney;

@property (nonatomic ,assign) id<BankAndOhterPayDelegate>delegate;


@end


