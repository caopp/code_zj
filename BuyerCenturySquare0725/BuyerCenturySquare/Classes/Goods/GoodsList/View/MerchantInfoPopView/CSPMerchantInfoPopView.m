//
//  CSPMerchantInfoPopView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantInfoPopView.h"
#import "MerchantShopDetailDTO.h"

@implementation CSPMerchantInfoPopView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (void)awakeFromNib {
    
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.layer.masksToBounds = YES;

    self.recordNoLabel.layer.cornerRadius = 2.0f;
    self.recordNoLabel.layer.masksToBounds = YES;
    
    //!点击空白去除界面
    UITapGestureRecognizer * contentViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSuperViewClick)];
    
    [self addGestureRecognizer:contentViewTapGesture];
    
    
}

-(void)removeSuperViewClick{

    [self removeFromSuperview];

}
- (IBAction)closeButtonClicked:(id)sender {
    
    [self removeFromSuperview];

}
//!重构后采用的方法
- (void)setupWithShopDto:(MerchantShopDetailDTO*)merchantShopDetail{

    
    self.merchantNameLabel.text = merchantShopDetail.merchantName;
    
    self.recordNoLabel.text = [NSString stringWithFormat:@"  %@: %@   ", NSLocalizedString(@"stallNum", @"档口号"),merchantShopDetail.stallNo];
    // !计算大小 ，改变大小
    CGSize  recordLabelSize = [self.recordNoLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:9]} context:nil].size;
    self.recordNumHight.constant = recordLabelSize.height + 5;//!为了好看，增加高度
    
    
    
    self.categoryLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopCategory", @"分类") ,merchantShopDetail.categoryName];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopAddress", @"地址") ,merchantShopDetail.addressDescription];
    
    self.telephoneLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopMobile", @"联系电话"), merchantShopDetail.mobilePhone];
    
    self.wechatLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"wechat", @"微信"),merchantShopDetail.wechatNo];
    
    self.introductionLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopSynopsis", @"简介"), merchantShopDetail.merchantDescription];
    
    

    
}
- (void)setupWithDictionary:(NSDictionary *)dictionary {
    
    
    MerchantShopDetailDTO* merchantShopDetail = [[MerchantShopDetailDTO alloc]initWithDictionary:dictionary];
    
    self.merchantNameLabel.text = merchantShopDetail.merchantName;

    self.recordNoLabel.text = [NSString stringWithFormat:@"  %@: %@   ", NSLocalizedString(@"stallNum", @"档口号"),merchantShopDetail.stallNo];
    // !计算大小 ，改变大小
    CGSize  recordLabelSize = [self.recordNoLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:9]} context:nil].size;
    self.recordNumHight.constant = recordLabelSize.height + 5;//!为了好看，增加高度
    
    
    
    self.categoryLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopCategory", @"分类") ,merchantShopDetail.categoryName];

    self.addressLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopAddress", @"地址") ,merchantShopDetail.addressDescription];

    self.telephoneLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopMobile", @"联系电话"), merchantShopDetail.mobilePhone];

    self.wechatLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"wechat", @"微信"),merchantShopDetail.wechatNo];

    self.introductionLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"shopSynopsis", @"简介"), merchantShopDetail.merchantDescription];
    
    
    
    
}

@end
