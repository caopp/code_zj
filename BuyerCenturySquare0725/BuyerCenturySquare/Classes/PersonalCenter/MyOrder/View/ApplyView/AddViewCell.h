//
//  AddViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplyDTO.h"

@interface AddViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextView *addTextView;


-(void)setAddTextViewContent:(RefundApplyDTO *)applyDTO withMostAlert:(NSString *)mostAlertStr;


@end
