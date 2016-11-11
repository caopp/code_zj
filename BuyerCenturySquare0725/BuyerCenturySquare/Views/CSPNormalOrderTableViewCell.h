//
//  CSPConfirmOrderTypeATableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseOrderTableViewCell.h"

@interface CSPNormalOrderTableViewCell : CSPBaseOrderTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray * sizeLabels;

@end
