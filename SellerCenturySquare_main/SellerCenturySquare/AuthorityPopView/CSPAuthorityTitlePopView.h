//
//  CSPAuthorityTitlePopView.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 9/2/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPAuthorityTitlePopView : UIView
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundeView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end
