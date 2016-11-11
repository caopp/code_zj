//
//  CSPPersonCenterShopTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "BadgeImageView.h"

@interface CSPPersonCenterShopTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet BadgeImageView *badgeimageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrorImageView;
@property (strong, nonatomic) IBOutlet UILabel *goodsNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *badgeHight;
@property (strong, nonatomic) IBOutlet CustomBadge *custombadge;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *badgeWith;
@end
