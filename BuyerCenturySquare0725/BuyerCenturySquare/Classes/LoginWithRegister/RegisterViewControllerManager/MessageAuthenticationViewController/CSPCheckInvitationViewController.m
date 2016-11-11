//
//  CSPCheckInvitationViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCheckInvitationViewController.h"
#import "CustomBarButtonItem.h"
@interface CSPCheckInvitationViewController ()

@end

@implementation CSPCheckInvitationViewController
- (IBAction)backRootBtnClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份验证";

    [self.navigationItem setHidesBackButton:YES];
    /**
     *  直接采用方法就可以了，storyboard上UI界面布置，按钮采用push方法，直接就可以进行下一个页面操作。
     */
//    [self addCustombackButtonItem];
    
//    //按钮的选中颜色
//    self.haveCodeButton.backgroundColor = LGButtonColor;
//    self.noCodeButton.backgroundColor = [ UIColor clearColor];
//    [self.haveCodeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    [self.noCodeButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
//    [self.noCodeButton.layer setBorderColor:LGButtonColor.CGColor];
//    [self.haveCodeButton.layer setBorderColor:LGButtonColor.CGColor];

    [self.haveCodeButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    [self.haveCodeButton.layer setBorderColor:LGButtonColor.CGColor];

}



/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
    
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)haveCodeBtnAction:(id)sender {
    
    self.haveCodeButton.backgroundColor = LGButtonColor;
    [self.haveCodeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.haveCodeButton.layer setBorderColor:LGButtonColor.CGColor];
    
    
    self.noCodeButton.backgroundColor = [ UIColor clearColor];
    [self.noCodeButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    [self.noCodeButton.layer setBorderColor:LGButtonColor.CGColor];
    
}

- (IBAction)noCodeBtnAction:(id)sender {
    
    self.noCodeButton.backgroundColor = LGButtonColor;
    [self.noCodeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.noCodeButton.layer setBorderColor:LGButtonColor.CGColor];
    
    
    self.haveCodeButton.backgroundColor = [ UIColor clearColor];
    [self.haveCodeButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    [self.haveCodeButton.layer setBorderColor:LGButtonColor.CGColor];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
