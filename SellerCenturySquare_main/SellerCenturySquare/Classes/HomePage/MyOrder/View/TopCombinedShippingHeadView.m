//
//  TopCombinedShippingHeadView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopCombinedShippingHeadView.h"
@interface TopCombinedShippingHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLab;
@property (weak, nonatomic) IBOutlet UILabel *merchantPhoneLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseMerchantBtn;

- (IBAction)chlickChooseMerchantBtn:(id)sender;

- (IBAction)selelctMerchantNameBtn:(id)sender;
- (IBAction)clickCustomerServiceBtn:(id)sender;


@end

@implementation TopCombinedShippingHeadView

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chlickChooseMerchantBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if ( self.recordMemberDto.orderList.count>0) {
        
        if (btn.selected) {
            self.recordMemberDto.headCheckBtn = @"YES";
        }else
        {
            self.recordMemberDto.headCheckBtn  = @"NO";
        }
        for (OrderListDTO *listDto in self.recordMemberDto.orderList) {
            
            if (btn.selected) {
                listDto.checkBtn = @"YES";
            }else
            {
                listDto.checkBtn = @"NO";
            }
            
        }
        if ([self.delegate respondsToSelector:@selector(myOrderParentSelectMerchantOrder:)]) {
            [self.delegate myOrderParentSelectMerchantOrder:self.recordMemberDto];
        }

    }
}

- (IBAction)selelctMerchantNameBtn:(id)sender {
    
    if ( [self.delegate respondsToSelector:@selector(myOrderParentSelectMerchantName:)]) {
        [self.delegate myOrderParentSelectMerchantName:self.recordMemberDto];
    }
    
}

- (IBAction)clickCustomerServiceBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectSerVice:)]) {
        [self.delegate myOrderParentSelectSerVice:self.recordMemberDto];
        
    }
    
    
}
- (void)setOrderLsitDto:(OrderListDTO *)orderLsitDto
{    
    
    if (orderLsitDto) {
        self.recordListDto = orderLsitDto;

        self.merchantNameLab.text = orderLsitDto.memberName;
        self.merchantPhoneLab.text = orderLsitDto.memberPhone;
        
        
    }
}

- (void)setMemberListDto:(MemberListDTO *)memberListDto
{
    [super setMemberListDto:memberListDto];
    self.recordMemberDto = memberListDto;
    
    if ([memberListDto.headCheckBtn isEqualToString:@"YES"]) {
        self.chooseMerchantBtn.selected = YES;
        
    }else
    {
        self.chooseMerchantBtn.selected = NO;
    }
    self.merchantPhoneLab.text = memberListDto.mobilePhone;
    self.merchantNameLab.text = memberListDto.nickName;
    
}

@end
