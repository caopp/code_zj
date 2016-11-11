//
//  CSPShoppingCartTypeCTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseCartTableViewCell.h"

@class CSPSkuControlView;

@interface CSPMailCartTableViewCell : CSPBaseCartTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet CSPSkuControlView* skuView;
@property (nonatomic, assign, getter=isValid) BOOL valid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceInvalidLabelConstraint;

@end
