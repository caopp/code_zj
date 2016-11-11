//
//  ExpressDeliverViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ExpressDeliverViewController : BaseViewController


@property (nonatomic , strong) NSString *orderCode;

//!发货成功的block
@property(nonatomic,copy)void (^takeExpressSuccessBlock)();





@end
