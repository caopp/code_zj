//
//  CSPApplyTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPApplyTableViewCell.h"

@implementation CSPApplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title content:(NSString*)content {
    self.titleNameLabel.text = title;
    self.contentLabel.text = content;
    
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    
    
    
}

@end
