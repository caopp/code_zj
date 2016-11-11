//
//  CSPCodeVerifyViewController.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPCodeVerifyViewController.h"
#import "CustomBarButtonItem.h"
#import "CustomTextField.h"
#import "CustomButton.h"
#import "LoginDTO.h"
#import "SaveUserIofo.h"
#import "UserOtherInfo.h"
#import "CSPFillAddressViewController.h"
#import "RegisteredView.h"
#import "CSPFillApplicationViewController.h"
@interface CSPCodeVerifyViewController ()<RegisteredViewDelegate>{
    UIView *view;
}
@property (strong, nonatomic) IBOutlet CustomTextField *checkCodeText;
@property (strong, nonatomic) IBOutlet CustomButton *verifityButton;

@end

@implementation CSPCodeVerifyViewController
-(void)viewWillAppear:(BOOL)animated{
        [self.navigationItem setHidesBackButton:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份验证";
    // Do any additional setup after loading the view.
     //[self addCustombackButtonItem];

    [self addTapHideKeyBoard];
    if (!_islogin) {
       // [self fillPersonalInformationPage];
    }
    
}

- (IBAction)codeVerify:(id)sender {
    if (![self.checkCodeText.text length]) {
          [self.view makeToast:@"邀请码不能为空" duration:2.0f position:@"center"];
        return;
    }
      self.verifityButton.userInteractionEnabled = NO;
    [HttpManager sendHttpRequestForCodeVerifyRegisterKeyCode:self.checkCodeText.text mobilePhone:[LoginDTO sharedInstance].memberAccount  success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         [_checkCodeText resignFirstResponder];
         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         
         self.verifityButton.userInteractionEnabled = YES;
         
         if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
             
             [self.view makeToast:@"邀请码验证通过" duration:2.0f position:@"center"];
             
             
             
             NSMutableDictionary *h5Dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                          
                                                                                          @"tokenId":[LoginDTO sharedInstance].tokenId,
                                                                                          
                                                                                          @"memberNo":[LoginDTO sharedInstance].memberNo,
                                                                                          
                                                                                          }];
             
             //保存信息到plist文件中  h5交互需要用到
             SaveUserIofo *saveIofo = [[SaveUserIofo alloc]init];
             [saveIofo addIofoDTO:h5Dic];
             
             
             //用户通过后进行其他地方登录
             //聊天登录
             UserOtherInfo *userOtherIofo = [[UserOtherInfo alloc]init];
             [userOtherIofo assignmentPhoneNumber:[MyUserDefault defaultLoadAppSetting_loginPhone] password:[MyUserDefault defaultLoadAppSetting_loginPassword]];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotice object:nil];
             
             //                //验证成功后进行页面跳转
             //                //更新window rootViewController
             //                AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
             //
             //                [delegate updateRootViewController];
             
             
         } else {
             
             //进行判断邀请码是否过期或者是言情吗错误
             [self.view makeToast:[NSString stringWithFormat:@"%@", [dic objectForKey:@"errorMessage"]]  duration:2.0 position:@"center"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.view makeToast:@"网络连接异常" duration:2.0f position:@"center"];
         self.verifityButton.userInteractionEnabled = YES;
         
     }];


}
- (IBAction)rigshtAdd:(id)sender {
    
    //注册成功后进入注册页面
    CSPFillAddressViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillAddressViewController"];
    securityCheckViewController.isRigst = YES;
    [self.navigationController pushViewController:securityCheckViewController animated:YES];

}
- (IBAction)greenPush:(id)sender {
    if (_isAddress) {
        CSPFillApplicationViewController *fillApplicationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillApplicationViewController"];
        
        
        [self.navigationController pushViewController:fillApplicationVC animated:YES];
    }else{
        //注册成功后进入注册页面
        CSPFillAddressViewController *securityCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPFillAddressViewController"];
        securityCheckViewController.isRigst = NO;
        [self.navigationController pushViewController:securityCheckViewController animated:YES];
    }


}
- (IBAction)loginout:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//注册成功后进入填写个人信息页面
-(void)fillPersonalInformationPage
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.alpha  = 0.7;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"background"];
    [view addSubview:imageView];
    [window addSubview:view];
    RegisteredView  * registeredView = [[[NSBundle mainBundle]loadNibNamed:@"RegisteredView" owner:self options:nil]lastObject];
    registeredView.userInteractionEnabled  = YES;
    registeredView.delegate = self;
    registeredView.center = imageView.center;
    [imageView addSubview:registeredView];
}

-(void)goOnCompleteRegisteredAction
{
    view.hidden = YES;
    //[self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
