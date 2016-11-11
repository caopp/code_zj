//
//  CSPLetterSentTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPLetterSentTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;

@end
