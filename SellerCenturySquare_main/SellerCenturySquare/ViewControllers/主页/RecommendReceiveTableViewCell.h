//
//  RecommendReceiveTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kModifyReceivePersonNotification @"ModifyReceivePersonNotification"

@interface RecommendReceiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiveL;
@property (nonatomic,assign) NSInteger num;

@end
