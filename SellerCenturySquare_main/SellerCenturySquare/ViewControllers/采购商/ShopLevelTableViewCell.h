//
//  ShopLevelTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMemberInfoDTO.h"
@interface ShopLevelTableViewCell : UITableViewCell
@property (nonatomic,strong) GetMemberInfoDTO *getMemberInfoDTO;
@property (weak, nonatomic) IBOutlet UILabel *shopLevelL;

@end
