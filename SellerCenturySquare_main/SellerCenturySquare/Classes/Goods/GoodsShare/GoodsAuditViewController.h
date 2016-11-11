//
//  GoodsAuditViewController.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsShareDTO.h"

typedef  NS_ENUM(NSInteger,AuditType){
    AuditTypePass = 1,
    AuditTypeDeductPass = 2,
    AuditTypeNoPass = 3
};
@interface GoodsAuditViewController : BaseViewController
@property(nonatomic,strong)NSNumber *labelId;
@property(nonatomic,assign)NSNumber *status;
@end
