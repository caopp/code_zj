//
//  DealViewCell.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"
#import "DownLoadRecordModel.h"
@interface DealViewCell : CSPBaseTableViewCell
//购买单价/次数

@property (strong, nonatomic) IBOutlet UILabel *digestLabel;

//购买份数

@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;

//购买金额

@property (strong, nonatomic) IBOutlet UILabel *totalamoutLabel;

//采购单号

@property (strong, nonatomic) IBOutlet UILabel *orderCodeLabel;


//购买时间
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;


-(void)settingModelParameters:(DownLoadRecordModel *)parameters;

@end
