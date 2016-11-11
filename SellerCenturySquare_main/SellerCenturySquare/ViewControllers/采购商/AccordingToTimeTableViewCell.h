//
//  AccordingToTimeTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberTradeDTO.h"
#import "MemberInviteDTO.h"

#define kAccordingToTimeTableViewCellToIM @"AccordingToTimeTableViewCellToIM"

@interface AccordingToTimeTableViewCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *redTitleL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *telephoneL;
@property (weak, nonatomic) IBOutlet UILabel *transactionL;
@property (weak, nonatomic) IBOutlet UIButton *shopLevelBtn;
@property (weak, nonatomic) IBOutlet UIButton *tradeLevelBtn;


@property (nonatomic,strong) id memberDTO;
@property (nonatomic,strong) NSMutableDictionary *IMInfo;

- (void)changeToAccordingTime;
- (void)changeToAccordingMoney;

@end
