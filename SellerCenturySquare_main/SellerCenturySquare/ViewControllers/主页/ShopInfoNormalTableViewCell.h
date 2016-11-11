//
//  ShopInfoNormalTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopInfoNormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoL;


-(void)getDetailInfoStr:(NSString *)str num:(NSNumber *)num;


@end
