//
//  CSPApplyLicenceTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplyLicenceTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CSPApplyLicenceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.idCardImageView.layer.cornerRadius = 3.0f;
    self.idCardImageView.layer.masksToBounds = YES;
    self.businessLicenceImageView.layer.cornerRadius = 3.0f;
    self.businessLicenceImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupIdCardImageURL:(NSURL *)idCardURL andBusinessLicenceImageURL:(NSURL *)businessLicenceURL {
    
    
    [self.idCardImageView sd_setImageWithURL:idCardURL placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    
    //!没有营业执照的时候隐藏
    if (![businessLicenceURL isEqual:[NSURL URLWithString:@""]]) {
        
        self.businessLicenceImageView.hidden = NO;
        self.businessLicenceLabel.hidden = NO;
        [self.businessLicenceImageView sd_setImageWithURL:businessLicenceURL placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];

    }else{
    
        self.businessLicenceImageView.hidden = YES;
        self.businessLicenceLabel.hidden = YES;
        
    }
}

@end
