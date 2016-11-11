//
//  CSPPicDownloadView.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"


@interface CSPPicDownloadView : SGBaseMenu
@property (weak, nonatomic) IBOutlet UIView *windowView;
@property (weak, nonatomic) IBOutlet UILabel *windowPicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *windowPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *windowPicDownloadedLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowPicButton;
- (IBAction)windowPicButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *impersonalityView;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityTitle;
@property (weak, nonatomic) IBOutlet UIImageView *impersonalityImageView;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityDownloadedLabel;
@property (weak, nonatomic) IBOutlet UIButton *impersonalityButton;
- (IBAction)impersonalityButtonClicked:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
- (IBAction)downloadButtonClicked:(UIButton *)sender;

- (void)triggerSelectedAction:(SGMenuActionHandler)actionHandle;
@end
