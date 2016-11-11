//
//  CSPPicDownloadingTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSPBaseTableViewCell.h"
#import "PictureDTO.h"

@protocol CSPPicDownloadingCellDelegate <NSObject>

- (void)windowSelected2Clicked:(UIButton *)sender;
- (void)windowPauseClicked:(UIButton *)sender;
- (void)impersonalitySelectedCliced:(UIButton *)sender;
- (void)impersonalityPauseClicked:(UIButton *)sender;

@end

@interface CSPPicDownloadingTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *windowTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *windowValueLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *windowProgressView;
@property (weak, nonatomic) IBOutlet UILabel *windowRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *windowProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowSelcetedButton;
- (IBAction)windowSelectedButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *windowPauseButton;
- (IBAction)windowPauseButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *impersonalityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *impersonalityProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *impersonalitySelectedButton;
- (IBAction)impersonalitySelectedButtonCliced:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *impersonalityProgressView;
@property (weak, nonatomic) IBOutlet UIButton *impersonalityPauseButton;
- (IBAction)impersonalityPauseButtonClicked:(id)sender;

@property (nonatomic,assign)id<CSPPicDownloadingCellDelegate>delegate;
//@property (nonatomic,strong)PictureDTO* pictureDTO;
//
//@property (nonatomic,strong)PictureDTO* pictureDTO1;
//
//@property (nonatomic,strong)PictureDTO* pictureDTO2;




@end
