//
//  TopOrderStateView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopOrderStateView.h"
#import "Masonry.h"


@interface TopOrderStateView ()
//待付款
@property (weak, nonatomic) IBOutlet UIView *waitPayView;
@property (weak, nonatomic) IBOutlet UIImageView *waitPayImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitPayLabHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitPayLabWidth;

@property (weak, nonatomic) IBOutlet UILabel *waitPayLab;
//标记

//待发货
@property (weak, nonatomic) IBOutlet UIView *waitDeliverView;
@property (weak, nonatomic) IBOutlet UIImageView *waitDeliverImage;
//标记
@property (weak, nonatomic) IBOutlet UILabel *waitDeliverLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitDeliverLabHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitDeliverLabWidth;


//待收货
@property (weak, nonatomic) IBOutlet UIView *waitReceiptView;
@property (weak, nonatomic) IBOutlet UIView *waitReceiptImage;
//标记
@property (weak, nonatomic) IBOutlet UILabel *waitReceiptLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitReceiptLabWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitReceiptLabHeight;


//全部订单
@property (weak, nonatomic) IBOutlet UIView *allOrderStateView;
@property (weak, nonatomic) IBOutlet UIImageView *allOrderStateImage;
//标记
@property (weak, nonatomic) IBOutlet UILabel *allOrderStateLab;




@end

@implementation TopOrderStateView

-(void)awakeFromNib
{
    self.waitPayImage.userInteractionEnabled = YES;
    self.waitDeliverImage.userInteractionEnabled = YES;
    self.waitReceiptImage.userInteractionEnabled = YES;
    self.allOrderStateImage.userInteractionEnabled = YES;
    
    
    //待付款
    UITapGestureRecognizer *waitPayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWaitPayTap)];
    [self.waitPayView addGestureRecognizer:waitPayTap];
    
    //待发货
    UITapGestureRecognizer *waitDeliverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWaitDelierTap)];
    [self.waitDeliverView addGestureRecognizer:waitDeliverTap];
    
    //待收货
    UITapGestureRecognizer *waitReceiptTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWaitReceiptTap)];
    [self.waitReceiptView addGestureRecognizer:waitReceiptTap];
    
    
    //全部订单
    UITapGestureRecognizer *allOrderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selelctAllOrderState)];
    [self.allOrderStateView addGestureRecognizer:allOrderTap];
    
    
    
    self.waitPayLab.layer.cornerRadius = 7.5f;
    self.waitDeliverLab.layer.cornerRadius = 7.5f;
    self.waitReceiptLab.layer.cornerRadius = 7.5f;
    self.waitPayLab.layer.masksToBounds = YES;
    self.waitDeliverLab.layer.masksToBounds = YES;
    self.waitReceiptLab.layer.masksToBounds = YES;
    
}

//待付款
- (void)selectWaitPayTap
{
    if (self.blockwaitPay) {
        self.blockwaitPay();
        
    }
}

//待收货
-(void)selectWaitDelierTap
{
    if (self.blockwaitDeliver) {
        self.blockwaitDeliver();
    }
}

//待发货
- (void)selectWaitReceiptTap
{
    if (self.blockwaitReceipt) {
        self.blockwaitReceipt();
        
    }
}

//全部订单
- (void)selelctAllOrderState
{
    if (self.blockAllOrderState) {
        self.blockAllOrderState();
    }
}

- (void)setMerchantMainDto:(GetMerchantMainDTO *)merchantMainDto
{
    //待付款
    
    
    if (merchantMainDto.notPayOrderNum.intValue>999) {
        self.waitPayLabWidth.constant = 7.5f;
        self.waitPayLabHeight.constant = 7.5f;
        
        self.waitPayLab.layer.cornerRadius = 3.25f;
        self.waitPayLab.layer.masksToBounds = YES;
    
        
    }else
    {
        if (merchantMainDto.notPayOrderNum.intValue>9) {
            self.waitPayLabWidth.constant = [self accordingContentFont:[NSString stringWithFormat:@"%d",merchantMainDto.notPayOrderNum.intValue]];
            
        }
        if (merchantMainDto.notPayOrderNum.intValue == 0) {
            self.waitPayLab.hidden = YES;
        }else
        {
            self.waitPayLab.hidden = NO;
        }
            
        
        self.waitPayLab.text = [NSString stringWithFormat:@"%d",merchantMainDto.notPayOrderNum.intValue];
    }
    
    //待发货
    if (merchantMainDto.unshippedNum.intValue>999) {
        
        self.waitDeliverLabWidth.constant = 7.5f;
        self.waitDeliverLabHeight.constant = 7.5f;
        
        self.waitDeliverLab.layer.cornerRadius = 3.25f;
        self.waitDeliverLab.layer.masksToBounds = YES;
        

        
    }else
    {
        self.waitDeliverLab.text = [NSString stringWithFormat:@"%d",merchantMainDto.unshippedNum.intValue];

        if (merchantMainDto.unshippedNum.intValue>9) {
            self.waitDeliverLabWidth.constant = [self accordingContentFont:self.waitDeliverLab.text];
            
        }
        
        if (merchantMainDto.unshippedNum.intValue == 0) {
            self.waitDeliverLab.hidden = YES;
        }else
        {
            self.waitDeliverLab.hidden = NO;
        }

    }
    
    //待收货
    if (merchantMainDto.untakeOrderNum.intValue>999) {
        
        self.waitReceiptLabWidth.constant = 7.5f;
        self.waitReceiptLabHeight.constant = 7.5f;
        
        self.waitReceiptLab.layer.cornerRadius = 3.25f;
        self.waitReceiptLab.layer.masksToBounds = YES;
        
    }else
    {
    
        self.waitReceiptLab.text = [NSString stringWithFormat:@"%d",merchantMainDto.untakeOrderNum.intValue];
        
        if (merchantMainDto.untakeOrderNum.intValue>9) {
            self.waitDeliverLabWidth.constant = [self accordingContentFont:self.waitReceiptLab.text];
            
        }
        if (merchantMainDto.untakeOrderNum.intValue == 0) {
            self.waitReceiptLab.hidden = YES;
        }else
        {
            self.waitReceiptLab.hidden = NO;
        }
        
    }
    

}


- (CGFloat)accordingContentFont:(NSString *)str
{
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;
    
    return size.width+8;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
