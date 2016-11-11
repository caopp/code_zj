//
//  OrderDetailFlowHeadView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/6.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDetailFlowHeadView.h"

@interface OrderDetailFlowHeadView ()

@property (weak, nonatomic) IBOutlet UIView *showTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTimeViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *mailImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeLabTop;

@end

@implementation OrderDetailFlowHeadView



- (void)setDetailDto:(OrderDetailDTO *)detailDto
{
    if (detailDto) {
        UILabel *recordLab;
        
        
        if (detailDto.mailTimesArr.count>0) {
            for (int i = 0 ; i<detailDto.mailTimesArr.count; i++) {
                
                if (i == 0) {
                    
                    self.orderTimeLab.text = detailDto.mailTimesArr[i];
                    recordLab = self.orderTimeLab;
                }else
                {
                    if (recordLab) {
                        UILabel *label = [[UILabel alloc] init];                        
                        [self.showTimeView addSubview:label];
                        label.text =  detailDto.mailTimesArr[i];
//                        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                        label.font = [UIFont systemFontOfSize:12];

                        label.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
                        
                        recordLab = label;
                        
                        
                    }
                    if (detailDto.mailTimesArr.count == (i+1)) {
                        CGFloat viewHeight =CGRectGetMaxY(recordLab.frame);
                        self.showTimeViewHeight.constant = viewHeight;
                        
                        
                    }
                }
            }
        }
        
        
//        if (detailDto.orderDelivery.count>0) {
//            OrderDeliveryDTO *orderliveDto = detailDto.orderDelivery[0];
//            [self.mailImageView sd_setImageWithURL:[NSURL URLWithString:orderliveDto.deliveryReceiptImage] placeholderImage:[UIImage imageNamed:@""]];
//        }else{
//            
//        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

