//
//  CSPPersonalProfileHeaderTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.


@protocol CSPPersonalProfileHeaderDelegate <NSObject>

- (void)changeHeader;

@end

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"


@interface CSPPersonalProfileHeaderTableViewCell : CSPBaseTableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *linelabel;
@property (weak, nonatomic) IBOutlet UIImageView *hederImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *nick;


@property (strong,nonatomic) UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (assign,nonatomic) id <CSPPersonalProfileHeaderDelegate> delegate;


@end
