//
//  BankAndOhterPayView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankAndOhterPayView.h"

@interface BankAndOhterPayView ()
//余额支付
@property (weak, nonatomic) IBOutlet UIView *balancePayView;

//支付宝支付
@property (weak, nonatomic) IBOutlet UIView *alipayView;
//微信支付
@property (weak, nonatomic) IBOutlet UIView *wechatView;
//微信支付按钮
@property (weak, nonatomic) IBOutlet UIButton *wechat_payBtn;
//支付宝支付按钮
@property (weak, nonatomic) IBOutlet UIButton *alipay_payBtn;
//支付金额
@property (weak, nonatomic) IBOutlet UILabel *payAmount;

//确认去支付
- (IBAction)confirmPayButton:(id)sender;

//



@end



@implementation BankAndOhterPayView
- (void)awakeFromNib{
    
    self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    self.confirmPayBtn.userInteractionEnabled = NO;
    
    //余额支付
    UITapGestureRecognizer *balancePayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBalancePayView)];
    [self.balancePayView addGestureRecognizer:balancePayTap];
    
    //微信支付
    UITapGestureRecognizer *wechaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWechatView)];
    [self.wechatView addGestureRecognizer:wechaTap];
    
    //支付宝支付
    UITapGestureRecognizer *alipayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAlipayView)];
    [self.alipayView addGestureRecognizer:alipayTap];
    
    
    
    
}

//点击余额支付
- (void)clickBalancePayView
{
    self.wechat_payBtn.selected = NO;
    self.alipay_payBtn.selected = NO;

    self.confirmPayBtn.userInteractionEnabled = NO;
    self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    [self.delegate bankAndOhterPayJumpVC];
    
    
    
}
//微信支付
- (void)clickWechatView
{
    if (self.alipay_payBtn.selected) {
        self.alipay_payBtn.selected = NO;
    }
    
    self.wechat_payBtn.selected = !self.wechat_payBtn.selected;
    
    if (self.wechat_payBtn.selected) {
        self.confirmPayBtn.userInteractionEnabled = YES;
        self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];

    }else
    {
        
        self.confirmPayBtn.userInteractionEnabled = NO;
         self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    }

}

//支付宝支付
- (void)clickAlipayView
{
    if (self.wechat_payBtn) {
        self.wechat_payBtn.selected = NO;
    }
    self.alipay_payBtn.selected = !self.alipay_payBtn.selected;
    if (self.alipay_payBtn.selected) {
        self.confirmPayBtn.userInteractionEnabled = YES;
        self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
        
    }else
    {
        self.confirmPayBtn.userInteractionEnabled = NO;
       self.confirmPayBtn.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    }


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setPayMoney:(NSNumber *)payMoney
{
    self.payAmount.text = [NSString stringWithFormat:@"%.2lf",payMoney.doubleValue];
    
}

//确认去充值

- (IBAction)confirmPayButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    
    NSString *payMethod = nil;
    
    if (self.wechat_payBtn.selected) {
        payMethod = @"WeChatMobile";
    }else if (self.alipay_payBtn.selected)
    {
        payMethod = @"AlipayQuick";
    }
    
    if (payMethod.length != 0) {
        [self.delegate bankAndOhterPayMethodPayment:payMethod];
        
        
    }
    
    
    
    
}
@end
