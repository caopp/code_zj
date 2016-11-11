//
//  SelectExpressViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//  !选中快点公司的vc

#import "BaseViewController.h"

@interface SelectExpressViewController : BaseViewController


@property(nonatomic,copy)void(^selectBlock)(NSMutableDictionary *);



@end
