//
//  CourierTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourierModel;
@interface CourierTableViewCell : UITableViewCell

//采购单地址
@property (nonatomic,strong)UILabel *courierAddressLabel;
//采购单时间
@property (nonatomic,strong)UILabel *courierTimeLabel;
//
@property (nonatomic,strong)UILabel *lineLabel;

@property (nonatomic,assign)CGFloat heightCell;

//按钮显示
@property (nonatomic,strong)UIButton *selectedButton;

//线体
@property (nonatomic,strong)UILabel *verticalLabel;
@property (nonatomic,strong)UILabel *underLabel;

-(void)getLookFreightTemplateCellData:(CourierModel *)data ;

@end
