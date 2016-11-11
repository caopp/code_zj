//
//  CPSBuyerViewController.h
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface CPSBuyerViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIView *firstButtonHideView;
@property (weak, nonatomic) IBOutlet UIView *midButtonHideView;
@property (weak, nonatomic) IBOutlet UIView *lastButtonHideView;

@property (weak, nonatomic) IBOutlet UIView *firstToolBarView;
@property (weak, nonatomic) IBOutlet UIView *midToolBarView;

@property (weak, nonatomic) IBOutlet UILabel *memberTradeCountL;
@property (weak, nonatomic) IBOutlet UILabel *memberInviteCountL;
@property (weak, nonatomic) IBOutlet UILabel *memberBlackCountL;

@property (weak, nonatomic) IBOutlet UIButton *accordingToMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *accordingToTimeButton;

@property (weak, nonatomic) IBOutlet UIButton *inviteAccordingToMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteAccordingToTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteUnAcceptButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;


@end
