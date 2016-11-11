//
//  BuyerDetailInfoTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMemberInfoDTO.h"
@interface BuyerDetailInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) id memberDTO;
@property (nonatomic,strong) GetMemberInfoDTO *getMemberInfoDTO;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *tradeLevelL;
@property (weak, nonatomic) IBOutlet UILabel *telephoneL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;



@end
