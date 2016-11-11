//
//  CSPShoppintCartTypeBTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseCartTableViewCell.h"

@interface CSPSampleCartTableViewCell : CSPBaseCartTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceInvalidLabelConstraint;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign, getter=isValid) BOOL valid;

@end
