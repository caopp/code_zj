//
//  CSPAmountControlView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicSkuDTO.h"
#import "DoubleSku.h"
/**
 *  设置选择框实现的样式
 */
typedef NS_ENUM(NSUInteger, CSPSkuControlViewStyle) {
    /**
     *  邮费专拍没有标题
     */
    CSPSkuControlViewStyleNoneTitle,
    /**
     *  标题和单个现货或期货的view显示
     */
    CSPSkuControlViewStyleSingleCounter,
    /**
     *  标题和现货期货view显示
     */
    CSPSkuControlViewStyleDoubleCounter,
};

@class CSPSkuControlView;

@protocol CSPSkuControlViewDelegate <NSObject>

@optional


- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue;

- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue valueType:(NSString*)valueType;

- (BOOL)skuControlView:(CSPSkuControlView*)skuControlView couldSkuValueChanged:(NSInteger)tagetValue;

- (void)skuControlView:(CSPSkuControlView *)skuControlView couldSkuAddCount:(NSString *)numb;



@end

@interface CSPSkuControlView : UIView


@property (nonatomic, assign) id<CSPSkuControlViewDelegate> delegate;
@property (nonatomic, assign) CSPSkuControlViewStyle style;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) NSInteger stockCounter;
@property (nonatomic, assign) NSInteger futureCounter;
//起批数量
@property (nonatomic, assign) NSInteger batchNumLimit;

@property (nonatomic ,strong) DoubleSku *doubleSku;

//期货单和现货单的数量
@property (nonatomic ,strong) NSString* totalNumb;

@property (nonatomic, strong) UILabel* titleLabel;
/**
 *  
 */
- (void)zoneGoodsInit;




@property (nonatomic, strong) BasicSkuDTO* skuValue;
-(void)changeBasicSkuDTO:(BasicSkuDTO*)dto;


@end
