//
//  CSPLoginViewController.h
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTextField2.h"
#import "CustomTextField.h"
//@protocol CSPLoginViewControllerDelegate <NSObject>
//
//-(void)setLoginViewControllerNav;
//
//@end


@interface CSPLoginViewController : BaseViewController
@property (strong, nonatomic) IBOutlet CustomTextField2 *phoneNumtextField;
@property (strong, nonatomic) IBOutlet CustomTextField *pswTextField;

//@property (weak,nonatomic)id<CSPLoginViewControllerDelegate>Delegate;


@property (nonatomic,assign)BOOL isOff;

@end
