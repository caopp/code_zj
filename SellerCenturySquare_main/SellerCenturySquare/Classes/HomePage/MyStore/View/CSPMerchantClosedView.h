//
//  CSPMerchantClosedView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !商家关闭

#import <UIKit/UIKit.h>

@protocol CSPMerchantClosedViewDelegate <NSObject>
@optional
-(void)backSubViewController;
- (void)reviewGoodsList;
- (void)reviewOtherList;

@end

typedef NS_ENUM(NSInteger, MerchantClosedViewType) {
    MerchantClosedViewTypeMerchantClosed,
    MerchantClosedViewTypeGoodsInvalid,
};

@interface CSPMerchantClosedView : UIView

@property (nonatomic, assign)id<CSPMerchantClosedViewDelegate> delegate;

// !很抱歉, 您查看的商家已关闭!
@property (weak, nonatomic) IBOutlet UILabel *closedAlertLabel;

// !您可以选择浏览其他商家或商品
@property (weak, nonatomic) IBOutlet UILabel *choiceAlertLabel;

// !选购商品
@property (weak, nonatomic) IBOutlet UIButton *choiceGoodsBtn;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

// !浏览商家
@property (weak, nonatomic) IBOutlet UIButton *reviewMerchantsButton;

@property (nonatomic, assign) MerchantClosedViewType type;
@end
