//
//  CSPShoppingCartTypeATableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseCartTableViewCell.h"


@class CSPSkuControlView;

@interface CSPNormalCartTableViewCell : CSPBaseCartTableViewCell

//颜色
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
//价格乘以数量
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

//失效
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceInvalidLabelConstraint;
/**
 *  所有显示现货，期货商品的尺寸
 */
@property (strong, nonatomic) IBOutletCollection(CSPSkuControlView) NSArray *skuViewList;

//期货
@property (weak, nonatomic) IBOutlet UILabel *futureLabel;
//现货
@property (weak, nonatomic) IBOutlet UILabel *spotLabel;
//提示数量变化
@property (weak, nonatomic) IBOutlet UILabel *redTipLabel;


@property (nonatomic, assign, getter=isValid) BOOL valid;

@end
