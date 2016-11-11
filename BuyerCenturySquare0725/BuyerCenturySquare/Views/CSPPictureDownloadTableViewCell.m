//
//  CSPPictureDownloadTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPictureDownloadTableViewCell.h"

@implementation CSPPictureDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)windowAgainButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowAgainClicked:)]) {
        [self.delegate windowAgainClicked:sender];
    }
}
- (IBAction)windowCleanButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowCleanClicked:)]) {
        [self.delegate windowCleanClicked:sender];
    }
}
- (IBAction)impersonalityButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalityClicked:)]) {
        [self.delegate impersonalityClicked:sender];
    }
}
- (IBAction)impersonalityCleanButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalityCleanClicked:)]) {
        [self.delegate impersonalityCleanClicked:sender];
    }
}
- (IBAction)windowSelectedButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowSelectedClicked:)]) {
        [self.delegate windowSelectedClicked:sender];
    }
}
- (IBAction)impersonalitySelectedButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(impersonalitySelectedClicked:)]) {
        [self.delegate impersonalitySelectedClicked:sender];
    }
}
@end
