//
//  CSPDownloadHistoryTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPDownloadHistoryTableViewCell.h"

@implementation CSPDownloadHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)windowSelectedButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowSelectClicked:)]) {
        [self.delegate windowSelectClicked:sender];
    }
}
- (IBAction)impersonalitySelectedButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalitySelectClicked:)]) {
        [self.delegate impersonalitySelectClicked:sender];
    }
}
@end
