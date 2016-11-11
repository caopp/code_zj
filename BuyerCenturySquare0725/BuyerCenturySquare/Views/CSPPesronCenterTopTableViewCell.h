//
//  CSPPesronCenterTopTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"
#import "CSPBaseTableViewCell.h"


@protocol CSPPersonCenterTopViewDelegate <NSObject>

- (void)toPayClicked;
- (void)toDeliverClicked;
- (void)toReciveClicked;
- (void)allClicked;

@end

@interface CSPPesronCenterTopTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet BadgeButton *toPayButton;
@property (weak, nonatomic) IBOutlet BadgeButton *todeliverButton;
@property (weak, nonatomic) IBOutlet BadgeButton *toRecive;
@property (weak, nonatomic) IBOutlet BadgeButton *allButton;
- (IBAction)toPayButtonClicked:(id)sender;
- (IBAction)toDeliverButtonClicked:(id)sender;
- (IBAction)toReciveButtonClicked:(id)sender;
- (IBAction)allButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *toPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *todeliverLabel;
@property (weak, nonatomic) IBOutlet UIButton *toReciveLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@property (nonatomic, assign)id <CSPPersonCenterTopViewDelegate>delegate;

@end
