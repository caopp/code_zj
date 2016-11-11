//
//  CSPVIPUpdateViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "GetMerchantInfoDTO.h"
#import "CustomBadge.h"

@interface CSPVIPUpdateViewController : BaseViewController

{
    GetMerchantInfoDTO *memDTO_;
}
@property (nonatomic,strong)GetMerchantInfoDTO *memDTO;
@property (weak, nonatomic) IBOutlet UIView *bottomTipsView;
@property (weak, nonatomic) IBOutlet UILabel *redTipL;
@property (weak, nonatomic) IBOutlet UILabel *bussinessScoreL;
@property (weak, nonatomic) IBOutlet UIView *redTipView;
@property (weak, nonatomic) IBOutlet UIView *blackTipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redHeight;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;



@end
