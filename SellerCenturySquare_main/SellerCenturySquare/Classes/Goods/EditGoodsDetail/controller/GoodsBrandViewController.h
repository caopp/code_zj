//
//  GoodsBrandViewController.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "BrandSearchGoodsDTO.h"
typedef void (^goodsbRrandBlock)(GoodsListDTO *goodsList);

@interface GoodsBrandViewController : BaseViewController

@property (nonatomic ,copy) NSString *goodsNo;

@property (nonatomic ,copy) goodsbRrandBlock goodsNameBlock;


@end
