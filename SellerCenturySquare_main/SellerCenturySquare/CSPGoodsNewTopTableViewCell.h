//
//  CSPGoodsNewTopTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPGoodsNewTopTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *v1Label;
@property (weak, nonatomic) IBOutlet UILabel *v2Label;
@property (weak, nonatomic) IBOutlet UILabel *v3Label;
@property (weak, nonatomic) IBOutlet UILabel *v4Label;
@property (weak, nonatomic) IBOutlet UILabel *v5Label;
@property (weak, nonatomic) IBOutlet UILabel *v6Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeightConstraint;

@end
