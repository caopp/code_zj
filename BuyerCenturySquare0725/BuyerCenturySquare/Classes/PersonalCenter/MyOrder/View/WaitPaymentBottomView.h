//
//  WaitPaymentBottomView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitPaymentBottomView : UIView

//type 0 客服  1退款
@property (nonatomic ,copy)void (^blockExitMoney)(NSInteger type);

//客服
@property (weak, nonatomic) IBOutlet UIButton *customerServiceBtn;
//退款
@property (weak, nonatomic) IBOutlet UIButton *exitMoneyBtn;
//退款宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exitMoneyBtnWidth;

//点击客服
- (IBAction)selecTexitMoneyBtn:(id)sender;
//点击退款
- (IBAction)selectCustomerServiceBtn:(id)sender;

@end


