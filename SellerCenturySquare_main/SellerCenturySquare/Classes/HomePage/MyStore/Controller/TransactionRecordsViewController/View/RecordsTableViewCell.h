//
//  RecordsTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TransactionRecordsModel.h"
@interface RecordsTableViewCell : UITableViewCell

//下载次数/钱数
@property (strong, nonatomic) IBOutlet UILabel *payDownloadLabel;
//采购单
@property (strong, nonatomic) IBOutlet UILabel *orderCodeLabel;
//购买时间
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
//总额
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
//份数
@property (strong, nonatomic) IBOutlet UILabel *additionalCopiesLabel;


-(void)settingModelParameters:(TransactionRecordsModel *)parameters;


@end
