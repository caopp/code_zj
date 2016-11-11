//
//  CSPOrderDetailSectionFooterView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderDetailSectionFooterView.h"
#import "OrderDetailDTO.h"
#import "UIImageView+WebCache.h"
#import "UUImageAvatarBrowser.h"

@implementation CSPOrderDetailSectionFooterView

- (void)awakeFromNib {
    [self.deliveryImageViewList enumerateObjectsUsingBlock:^(UIImageView* obj, NSUInteger idx, BOOL *stop) {
        [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        obj.tag = 1000 + idx;
        obj.userInteractionEnabled = YES;
    }];
}

- (void)setOrderDetailInfo:(OrderDetailDTO *)orderDetailInfo {
    _orderDetailInfo = orderDetailInfo;

    NSArray* timeList = [orderDetailInfo deliveryStatusTimeList];

    [self.deliveryLabelList enumerateObjectsUsingBlock:^(UILabel* obj, NSUInteger idx, BOOL *stop) {
        if (idx < timeList.count) {
            [obj setHidden:NO];
            
            [obj setText:timeList[idx]];
            
            NSString* cutOutStr = [timeList[idx] substringToIndex:4];//截取下标7之前的字符串
            
            if (idx == 0 && [cutOutStr isEqualToString:@"自动确定"]) {
                
                obj.text = nil;
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:timeList[idx]];
                NSUInteger length = [timeList[idx] length] - 13;
                
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0xeb301f alpha:1] range:NSMakeRange(13,length)];
                obj.attributedText = str;
                
                
            }

        } else {
            [obj setHidden:YES];
        }
    }];

    self.topSpaceLayoutConstraint.constant = 12 + 19 * timeList.count;

    [self.deliveryImageViewList enumerateObjectsUsingBlock:^(UIImageView* obj, NSUInteger idx, BOOL *stop) {
        if (idx < orderDetailInfo.orderDeliveryList.count) {
            [obj setHidden:NO];

            OrderDelivery* orderDelivery = orderDetailInfo.orderDeliveryList[idx];
            [obj sd_setImageWithURL:[NSURL URLWithString:orderDelivery.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
        } else {
            [obj setHidden:YES];
        }
        
    }];
}

- (void)imageViewClick:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIImageView *imageView = (UIImageView*) tap.view;

    [UUImageAvatarBrowser showImage:imageView];
}

+ (CGFloat)sectionHeightWithOrderDetail:(OrderDetailDTO *)orderDetailInfo {
    NSArray* timeList = [orderDetailInfo deliveryStatusTimeList];

    CGFloat imageViewOriginY = 12 + 19 * timeList.count;
    if (orderDetailInfo.orderDeliveryList.count > 0) {
        NSInteger imageLineCount = orderDetailInfo.orderDeliveryList.count % 2 + orderDetailInfo.orderDeliveryList.count / 2;
        return imageViewOriginY + 70 * imageLineCount + 22;
    } else {
        return imageViewOriginY + 20;
    }

}


@end
