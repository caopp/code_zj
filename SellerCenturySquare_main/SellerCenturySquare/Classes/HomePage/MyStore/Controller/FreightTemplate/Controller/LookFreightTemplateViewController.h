//
//  LookFreightTemplateViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger,LookManager)
{
    goodsLookManager = 1,
    
    storeLookManager = 2
};

@interface LookFreightTemplateViewController : BaseViewController
//获取题目
@property (nonatomic,strong)NSString *lookTitle;
//获取模版id
@property(nonatomic,strong)NSNumber* Id;

@property (nonatomic,assign)LookManager lookManager;

@property (nonatomic,strong)NSString *productTitle;

//判断系统默认，进行浮框显示
@property (nonatomic,copy)NSString *isDefault;

@property (nonatomic,copy)NSNumber *goodID;







@end
