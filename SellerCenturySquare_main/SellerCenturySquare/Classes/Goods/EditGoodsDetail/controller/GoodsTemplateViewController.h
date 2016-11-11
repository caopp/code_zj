//
//  GoodsTemplateViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^GoodsTemplateBlock) (NSString *templateID,NSString *templateName);

@interface GoodsTemplateViewController : UIViewController

@property (nonatomic,strong)GoodsTemplateBlock templateBlock;



//商品编码
@property (nonatomic,strong)NSString *goodNo;
//商品模版id
@property (nonatomic,strong)NSString *goodsTemplateID;

@end
