//
//  CSPSkuView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPSkuView : CSPBaseCustomView

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsStateLabel;

@property (assign,nonatomic)BOOL isSelected;

@property (nonatomic,copy)void (^selectedBlock)(BOOL isSelected);


@end
