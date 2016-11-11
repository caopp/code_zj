//
//  CombinedShippingViewController.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^blockRequest)();

@interface CombinedShippingViewController : BaseViewController
//传入商家编号
@property (nonatomic ,copy) NSString *merchantNo;

//请求刷新
@property (nonatomic ,copy) blockRequest requestBlock;




@end
