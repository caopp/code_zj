//
//  ReturnReasonViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ReturnReasonViewCell.h"

@implementation ReturnReasonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectBtn.layer.borderWidth = 0.5;
    self.selectBtn.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;

    [self.filterLabel setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.selectBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//!原因选择框
- (IBAction)selectBtnClick:(id)sender {
    
    if (self.reasonSelectBlock) {
        
        self.reasonSelectBlock(self.isReturnReason,self.inIndexPath);
        
    }
    
}

//!这个方法可用于退货原因选择、货物状态选择，确定是"货物状态"还是"退货原因"
-(void)isReturnReasonSelect:(BOOL)isReturnReason  withApplyDTO:(RefundApplyDTO *)applyDTO{

    self.isReturnReason = isReturnReason;
    
    if (isReturnReason) {//!"退货原因"
        
        [self.leftLabel setText:@"退货原因:"];
        [self.selectBtn setTitle:@" 请选择退货原因" forState:UIControlStateNormal];
        
        //!根据dto内容显示
        if (applyDTO.refundReason && ![applyDTO.refundReason isEqual:@""]) {
            
            NSDictionary * getNumDic = @{@"0":@"质量问题",
                                         @"1":@"尺码问题",
                                         @"2":@"少件/破损",
                                         @"3":@"卖家发错货",
                                         @"4":@"未按约定时间发货",
                                         @"5":@"多拍/拍错/不想要",
                                         @"6":@"快递/物流问题",
                                         @"7":@"空包裹/少货",
                                         @"8":@"其他"};

            NSString * title = [NSString stringWithFormat:@" %@",getNumDic[[NSString stringWithFormat:@"%@",applyDTO.refundReason]]];
            
            [self.selectBtn setTitle:title forState:UIControlStateNormal];
            
        }
        
        
    }else{//!"货物状态"
    
        [self.leftLabel setText:@"货物状态:"];
        [self.selectBtn setTitle:@" 请选择货物状态" forState:UIControlStateNormal];
        //!根据dto内容显示
        if (applyDTO.goodsStatus && ![applyDTO.goodsStatus isEqual:@""]) {
            
            NSDictionary * getNumDic = @{@"0":@"未收到货",
                                         @"1":@"已收到货",
                                         };

            NSString * title = [NSString stringWithFormat:@" %@",getNumDic[[NSString stringWithFormat:@"%@",applyDTO.goodsStatus]]];
            
            [self.selectBtn setTitle:title forState:UIControlStateNormal];
            
            
        }

    }

}


@end
