//
//  SetBlackListTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetBlackListTableViewCell : UITableViewCell
@property (nonatomic ,copy) NSString *memberName;
@property (nonatomic ,assign) BOOL isInBlackList;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *noticeL;



@end
