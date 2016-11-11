//
//  NewTemplateViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ManageTemplate)
{
    AddNewTemplate = 1,
    ModifyTemplate = 2,
};

@interface NewTemplateViewController : UIViewController

@property (nonatomic,assign)ManageTemplate manageTemplate;

@property (nonatomic,strong)NSString *templateName;

@property (nonatomic,strong)NSNumber *templateID;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSMutableArray *lookList;

@end
