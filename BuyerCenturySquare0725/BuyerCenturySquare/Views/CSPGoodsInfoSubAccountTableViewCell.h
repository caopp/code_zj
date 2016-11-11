//
//  CSPGoodsInfoSubAccountTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "GoodsInfoDetailsDTO.h"
#import "CartDTO.h"

#define kConsultAndSettleButtonClickedNotification @"ConsultAndSettleButtonClickedNotification"

@interface CSPGoodsInfoSubAccountTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startNumL;
@property (weak, nonatomic) IBOutlet UILabel *hasSelectedNumL;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,copy)NSString *hasSelectedModel;//0 选择，1 未选择
@property (nonatomic,strong)GoodsInfoDetailsDTO *goodsInfo;


- (void)setStartNum:(NSNumber*)num;
- (void)setHasSelectedNum:(NSInteger)num;
@end
