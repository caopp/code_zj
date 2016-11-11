//
//  CSPLoginViewController.h
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTextField2.h"
#import "CSPApplicationInfoViewController.h"


@interface CSPLoginViewController : BaseViewController

@property (strong, nonatomic) IBOutlet CustomTextField2 *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet CustomTextField *passwordTextField;

//!是token失效过来的
@property(nonatomic,assign)BOOL isFromTokenLoseEfficacy;


//@property (weak, nonatomic) IBOutlet CustomTextField2 *phoneNumberTextField;
//@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;

@end
