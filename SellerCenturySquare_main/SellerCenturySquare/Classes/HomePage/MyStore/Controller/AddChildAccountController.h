//
//  AddChildAccountController.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^blockRequest)();
@interface AddChildAccountController : BaseViewController
@property (nonatomic ,strong)NSArray *dataArr;
//返回上一页刷新数据
@property (nonnull ,copy) blockRequest block;


@end
