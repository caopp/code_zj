//
//  InviteTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "InviteTableViewCell.h"
#import "InviteTableViewController.h"
@implementation InviteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteButtonClicked:(id)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:kPushNotification object:nil];
}


@end
