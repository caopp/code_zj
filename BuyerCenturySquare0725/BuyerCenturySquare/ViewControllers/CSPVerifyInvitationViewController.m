//
//  CSPVerifyInvitationViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPVerifyInvitationViewController.h"
#import "CustomTextField.h"
#import "LoginDTO.h"

@interface CSPVerifyInvitationViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *checkCodeTextField;

@end

@implementation CSPVerifyInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全校验";

    [self addCustombackButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verifyButtonClicked:(id)sender {

    NSString* checkCode = self.checkCodeTextField.text;
    if (checkCode.length > 0) {
        [HttpManager sendHttpRequestForVerifyRegisterKeyCode:checkCode mobilePhone:[LoginDTO sharedInstance].memberAccount success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                [self.view makeToast:@"邀请码验证通过" duration:2.0f position:@"center"];
                [self performSegueWithIdentifier:@"toSignUpComplete" sender:self];
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"邀请码验证失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
        }];
    } else {
        [self.view makeToast:@"邀请码错误" duration:2.0f position:@"center"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
