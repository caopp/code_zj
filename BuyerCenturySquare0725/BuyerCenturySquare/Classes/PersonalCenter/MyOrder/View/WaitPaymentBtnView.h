//
//  WaitPaymentBtnView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WaitPaymentDelegate  <NSObject>

- (void)waitPaymentCancelOrder;
- (void)waitPaymentConfirm;
- (void)waitPaymentCustomService;




@end

@interface WaitPaymentBtnView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;

@property (nonatomic ,assign) id<WaitPaymentDelegate>delegate;

- (IBAction)selectCancelOrderBtn:(id)sender;
- (IBAction)selectPaymentBtn:(id)sender;
- (IBAction)selectCustomServerBtn:(id)sender;

@end

