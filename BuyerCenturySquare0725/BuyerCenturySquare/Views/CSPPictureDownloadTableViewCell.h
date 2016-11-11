//
//  CSPPictureDownloadTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSPPicDownloadedCellDelegate <NSObject>

- (void)windowAgainClicked:(UIButton *)sender;
- (void)windowCleanClicked:(UIButton *)sender;
- (void)windowSelectedClicked:(UIButton *)sender;

- (void)impersonalityClicked:(UIButton *)sender;
- (void)impersonalityCleanClicked:(UIButton *)sender;
- (void)impersonalitySelectedClicked:(UIButton *)sender;


@end

#import "CSPBaseTableViewCell.h"

@interface CSPPictureDownloadTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *windowLabel;
@property (weak, nonatomic) IBOutlet UILabel *windowValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowAgainButton;
- (IBAction)windowAgainButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *windowCleanButton;
- (IBAction)windowCleanButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *windowSelectedButton;
- (IBAction)windowSelectedButtonClicked:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *impersonalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *impersonalityAgainButton;
- (IBAction)impersonalityButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *impersonalityCleanButton;
- (IBAction)impersonalityCleanButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *impersonalitySelectedButton;
- (IBAction)impersonalitySelectedButtonClicked:(id)sender;

@property (nonatomic,assign)id<CSPPicDownloadedCellDelegate>delegate;


@end
