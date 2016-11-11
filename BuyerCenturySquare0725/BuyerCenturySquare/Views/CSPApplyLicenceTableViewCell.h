//
//  CSPApplyLicenceTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPApplyLicenceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *businessLicenceImageView;

@property (strong, nonatomic) IBOutlet UILabel *businessLicenceLabel;

- (void)setupIdCardImageURL:(NSURL*)idCardURL andBusinessLicenceImageURL:(NSURL*)businessLicenceURL;

@end
