//
//  CSPPersonCenterLetterTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeImageView.h"
#import "CSPBaseTableViewCell.h"

@interface CSPPersonCenterLetterTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet BadgeImageView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
