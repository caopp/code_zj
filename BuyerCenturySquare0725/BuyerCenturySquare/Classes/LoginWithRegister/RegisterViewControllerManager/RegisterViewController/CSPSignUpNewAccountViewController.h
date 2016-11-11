//
//  CSPSignUpNewAccountViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

typedef void (^blockPhoneNum)();
@interface CSPSignUpNewAccountViewController : BaseViewController
@property(nonatomic,strong)blockPhoneNum phoneNum;

@end
