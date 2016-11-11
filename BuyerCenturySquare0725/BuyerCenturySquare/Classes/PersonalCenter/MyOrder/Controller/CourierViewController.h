//
//  CourierViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierViewController : UIViewController


//!快递公司code
@property(nonatomic,copy)NSString * expressCompanyCode;


//!快递单号
@property(nonatomic,copy)NSString * expressNO;


//快递公司名字
@property(nonatomic,copy)NSString *CourierName;

@end
