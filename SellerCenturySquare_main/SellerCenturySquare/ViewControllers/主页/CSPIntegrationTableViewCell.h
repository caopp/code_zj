//
//  CSPIntegrationTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPIntegrationTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enterImageView;
@end
