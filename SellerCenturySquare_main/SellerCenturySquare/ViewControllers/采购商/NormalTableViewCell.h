//
//  NormalTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBlackDTO.h"
#import "MemberInviteDTO.h"

#define kRemoveFromBlackListNotification @"RemoveFromBlackListNotification"
@interface NormalTableViewCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *telephoneL;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;

@property (nonatomic,strong) id memberDTO;

- (void)changeToBlackListState:(BOOL)blackListState;

@end
