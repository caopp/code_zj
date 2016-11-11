//
//  CSPConfirmOrderTypeBTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSampleOrderTableViewCell.h"

@implementation CSPSampleOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.sampleLab.layer.borderWidth = 0.5f;
    self.sampleLab.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
