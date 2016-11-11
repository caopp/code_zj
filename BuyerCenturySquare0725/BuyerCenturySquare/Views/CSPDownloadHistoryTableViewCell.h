//
//  CSPDownloadHistoryTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSPDownloadHistoryCellDelegate <NSObject>

- (void)windowSelectClicked:(UIButton *)sender;
- (void)impersonalitySelectClicked:(UIButton *)sender;

@end
#import "CSPBaseTableViewCell.h"

@interface CSPDownloadHistoryTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *windowTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *windowValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowSelectedButton;
- (IBAction)windowSelectedButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *impersonalitySelectedButton;
- (IBAction)impersonalitySelectedButtonClicked:(id)sender;

@property (nonatomic,assign)id<CSPDownloadHistoryCellDelegate>delegate;

@end
