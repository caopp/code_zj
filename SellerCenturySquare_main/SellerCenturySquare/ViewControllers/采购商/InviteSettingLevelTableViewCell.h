//
//  InviteSettingLevelTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteContactInfoDTO.h"
#define kContactSelectedNotification @"ContactSelectedNotification"
@interface InviteSettingLevelTableViewCell : UITableViewCell
@property (nonatomic,strong) InviteContactInfoDTO *inviteContactInfoDTO;

@property (weak, nonatomic) IBOutlet UIButton *level1Button;
@property (weak, nonatomic) IBOutlet UIButton *level2Button;
@property (weak, nonatomic) IBOutlet UIButton *level3Button;
@property (weak, nonatomic) IBOutlet UIButton *level4Button;
@property (weak, nonatomic) IBOutlet UIButton *level5Button;
@property (weak, nonatomic) IBOutlet UIButton *level6Button;


@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *onlyNameL;


- (void)setAuthState:(BOOL)hasAuth;

@end
