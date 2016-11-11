//
//  CSPBoughtMerchantTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBoughtMerchantTableViewCell.h"
#import "BoughtDTO.h"
#import "UIImageView+WebCache.h"
#import "MerchantListDetailsDTO.h"

@interface CSPBoughtMerchantTableViewCell ()


@end

@implementation CSPBoughtMerchantTableViewCell

- (void)awakeFromNib {
    // Initialization code

    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMerchantInfo:(MerchantListDetailsDTO *)merchantInfo {
    _merchantInfo = merchantInfo;
    
    self.merchantNameLabel.text = self.merchantInfo.merchantName;

    self.stallNoLabel.text = self.merchantInfo.stallNo;

    self.categoryLabel.text = self.merchantInfo.categoryName;

    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.merchantInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
}

- (void)setupWithDictionary:(NSDictionary*)dictionary {
    self.merchantInfo = [[MerchantListDetailsDTO alloc]initWithDictionary:dictionary];

    self.merchantNameLabel.text = self.merchantInfo.merchantName;

    self.stallNoLabel.text = self.merchantInfo.stallNo;

    self.categoryLabel.text = self.merchantInfo.categoryName;

    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.merchantInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
}
- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:startEnquiryWithMerchant:)]) {
        [self.delegate tableViewCell:self startEnquiryWithMerchant:self.merchantInfo];
    }
}

@end
