//
//  ZJ_TemplateiewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger,TemplateManage)
{
    NewTemplate = 1,
    OldModifyTemplate = 2,
    
};

@interface ZJ_TemplateiewController : BaseViewController

@property (nonatomic,assign)TemplateManage templatemanage;

@property (nonatomic,strong)NSString *templateName;

@property (nonatomic,strong)NSNumber *templateID;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSMutableArray *lookList;
@end
