//
//  CSPAuthorityTitlePopView.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 9/2/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol CSPAuthorityTitlePopViewDelegate <NSObject>

- (void)actionWhenPopViewDimiss;
- (void)gotoBuyDownloadTimes;

@end

@interface CSPAuthorityTitlePopView : UIView
@property (nonatomic,strong) id<CSPAuthorityTitlePopViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIButton *buyTimesButton;

- (IBAction)buyTimesButtonClicked:(id)sender;



@end
