//
//  CSPApplyEditeViewController.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "UserApplyInfo.h"
@interface CSPApplyEditeViewController : BaseViewController
@property(nonatomic,assign)BOOL firstFlag;//首次申请
@property(nonatomic,assign)BOOL noPass;//审核不通过
@property(nonatomic,strong)UserApplyInfo *applyDefault;
@end
