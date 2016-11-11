//
//  AddressDetailCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressDetailCell : UITableViewCell
//名字
@property (nonatomic,strong)UILabel *nameLabel;

//详细地址
@property (nonatomic,strong)UILabel *detailLabel;


-(void)getHeight:(CGSize )size;



@end
