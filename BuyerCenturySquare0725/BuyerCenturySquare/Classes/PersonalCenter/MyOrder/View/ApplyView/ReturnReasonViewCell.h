//
//  ReturnReasonViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplyDTO.h"

@interface ReturnReasonViewCell : UITableViewCell

//!退货原因选择 返回 这个cell给的状态:退货原因选择、货物状态 、对应的行
@property(nonatomic,copy) void(^reasonSelectBlock)(BOOL isSelectReturnReason,NSIndexPath * inIndexPath);

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!记录对应的行
@property(nonatomic,strong)NSIndexPath * inIndexPath;

//!记录这个cell给的状态:退货原因选择、货物状态
@property(nonatomic,assign)BOOL isReturnReason;

//!这个类可用于退货原因选择、货物状态选择
-(void)isReturnReasonSelect:(BOOL)isReturnReason withApplyDTO:(RefundApplyDTO *)applyDTO;


@end
