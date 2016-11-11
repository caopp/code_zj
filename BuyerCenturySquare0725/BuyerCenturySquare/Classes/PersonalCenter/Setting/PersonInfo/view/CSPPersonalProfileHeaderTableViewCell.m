//
//  CSPPersonalProfileHeaderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPersonalProfileHeaderTableViewCell.h"

@implementation CSPPersonalProfileHeaderTableViewCell

- (void)awakeFromNib {
    
    self.hederImageView.layer.masksToBounds=YES;
    
    self.hederImageView.layer.cornerRadius = self.hederImageView.frame.size.width/2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped:)];
    
    [self.hederImageView addGestureRecognizer:tap];
    
    self.hederImageView.userInteractionEnabled = YES;
    
    _nick.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    self.lineLabel = [[UILabel alloc]init];
    
    self.lineLabel.frame = CGRectMake(0, _nick.frame.size.height + _nick.frame.origin.y, SCREEN_WIDTH, 0.5);
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:0.6];
//    [self.contentView addSubview:self.lineLabel];
    
//    self.heightConstraint.constant = 0.5;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)headerImageViewTaped:(UITapGestureRecognizer *)gesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeHeader)]) {
        [self.delegate changeHeader];
    }
}

@end
