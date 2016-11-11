//
//  SetLevelBuyerInfoTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetLevelBuyerInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *levelInfoL;

- (void)setLevel:(NSInteger)level;
@end
