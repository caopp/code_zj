//
//  SecurityVerificationViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface SecurityVerificationViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeT;
@property (weak, nonatomic) IBOutlet UILabel *tipsL;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
