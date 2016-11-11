//
//  CSPApplyTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPApplyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHight;

- (void)setTitle:(NSString*)title content:(NSString*)content;

@end
