//
//  CSPMerchantInfoPopView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantInfoPopView.h"
#import "GetMerchantInfoDTO.h"

@implementation CSPMerchantInfoPopView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView.layer.cornerRadius = 15.0f;
        self.contentView.layer.masksToBounds = YES;
        
      
        
        
    }

    return self;
}

- (void)awakeFromNib {
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
    
    //!档口号
    self.recordNoLabel.layer.masksToBounds = YES;
    self.recordNoLabel.layer.cornerRadius = 2;
    
}

- (IBAction)closeButtonClicked:(id)sender {
    [self removeFromSuperview];
}

- (void)setupWithDictionary:(NSDictionary *)dictionary {
    GetMerchantInfoDTO* merchantShopDetail = [[GetMerchantInfoDTO alloc]initWithDictionary:dictionary];
//    [merchantShopDetail setDictFrom:dictionary];

    self.recordNoLabel.text = [NSString stringWithFormat:@"  档口号:%@  ",merchantShopDetail.stallNo];
    
    
    // !计算大小 ，改变大小
    CGSize  recordLabelSize = [self.recordNoLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:9]} context:nil].size;
    
    self.recordNoHight.constant = recordLabelSize.height + 5;//!为了好看，增加高度
    
    
    self.categoryLabel.text = [NSString stringWithFormat:@"分类:%@",merchantShopDetail.categoryName];
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@", [merchantShopDetail convertToCompleteAddress]];

    self.telephoneLabel.text = [NSString stringWithFormat:@"联系电话: %@", merchantShopDetail.mobilePhone];

    self.wechatLabel.text = [NSString stringWithFormat:@"微信: %@", merchantShopDetail.wechatNo];

    self.introductionLabel.text = [NSString stringWithFormat:@"简介: %@", merchantShopDetail.Description];
    
    self.merchantNameLabel.text = merchantShopDetail.merchantName;
    
}

@end
