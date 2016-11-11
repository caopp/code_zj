//
//  CSPAmountControlView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicSkuDTO.h"

typedef NS_ENUM(NSUInteger, CSPSkuControlViewStyle) {
    CSPSkuControlViewStyleNoneTitle,
    CSPSkuControlViewStyleSingleCounter,
    CSPSkuControlViewStyleDoubleCounter,
};

@class CSPSkuControlView;

@protocol CSPSkuControlViewDelegate <NSObject>

@optional
- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue;

- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue valueType:(NSString*)valueType;

- (BOOL)skuControlView:(CSPSkuControlView*)skuControlView couldSkuValueChanged:(NSInteger)tagetValue;

@end

@interface CSPSkuControlView : UIView

@property (nonatomic, assign) id<CSPSkuControlViewDelegate> delegate;
@property (nonatomic, assign) CSPSkuControlViewStyle style;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) NSInteger stockCounter;
@property (nonatomic, assign) NSInteger futureCounter;

@property (nonatomic, strong) BasicSkuDTO* skuValue;

@end
