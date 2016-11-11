
//
//  ConnectServiceViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUAAlertView.h"

@interface ConnectServiceViewCell : UITableViewCell
{

    GUAAlertView *  customAlertView;

}
@property (weak, nonatomic) IBOutlet UILabel *topFilterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFilterLabelHight;


@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (weak, nonatomic) IBOutlet UIButton *connectBtn;


@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterLabelHight;


@end
