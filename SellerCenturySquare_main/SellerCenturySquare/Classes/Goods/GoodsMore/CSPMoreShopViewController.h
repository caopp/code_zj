//
//  CSPMoreShopViewController.h
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/20.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "BaseViewController.h"
typedef enum _ObjectStyle {
    ObjectStyleForment=0,
    ObjectStyleObject=1,
    ObjectStyleAttr=2
} ObjectStyle;
@interface CSPMoreShopViewController : BaseViewController

@property (nonatomic ,copy) NSString *goodsNo;
@property (nonatomic,copy) NSString *shareCode;
//!分享类

@end
