//
//  SettingTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (void)updateButtonOnEditedState:(BOOL)edited;
@end
