//
//  MyOrderPromptTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderAddDTO.h"

@interface MyOrderPromptTableViewCell : UITableViewCell
/**
 *  采购单状态现货、期货
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

/**
 *  店铺名称
 */
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLab;

/**
 *  采购单应付
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPayLab;

/**
 *  采购单金额
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPayMoneyLab;

@property (nonatomic ,strong) CannotPayOrdersDTO *cannnotDto;
@property (nonatomic ,strong) CanPayOrdersDTO *canDto;


@end
