//
//  CSPOrderActionUtils.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/21/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#ifndef BuyerCenturySquare_CSPOrderActionUtils_h
#define BuyerCenturySquare_CSPOrderActionUtils_h

typedef NS_ENUM(NSInteger, CSPOrderMode) {
    CSPOrderModeAll, 
    CSPOrderModeToPay,
    CSPOrderModeToDispatch,
    CSPOrderModeToTakeDelivery,
    CSPOrderModeDealCompleted,
    CSPOrderModeOrderCanceled,
    CSPOrderModeDealCanceled
};

typedef NS_ENUM(NSUInteger, CartGoodsType) {
    CartGoodsTypeOfNormal,
    CartGoodsTypeOfSample,
    CartGoodsTypeOfMail,
};


#endif
