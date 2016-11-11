//
//  ChangeAccountController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ChangeAccountController.h"
#import "ManagementChildAccountView.h"
#import "ChildAccountController.h"
#import "HttpManager.h"
#import "Masonry.h"
@interface ChangeAccountController ()<ManagementChildAccountDelegate ,MBProgressHUDDelegate>
{
    ManagementChildAccountView *managementV;
    
}

@property (nonatomic ,strong) UIButton *saveBtn;

@end

@implementation ChangeAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tintColor = [UIColor blackColor];
    
    leftBtn.frame = CGRectMake(0, 0, 10,18);
    
    [leftBtn setImage:[UIImage imageNamed:@"nav_retrun_btn"] forState:UIControlStateNormal];
    [leftBtn  addTarget:self action:@selector(popNavVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    
    self.title = @"子账号";
    managementV =  [[[NSBundle mainBundle] loadNibNamed:@"ManagementChildAccountView" owner:nil options:nil] lastObject];
    [self.view addSubview:managementV];
    managementV.delegate = self;
    [managementV accpetToSendData:self.dataDict];
    managementV.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y       , self.view.frame.size.width, self.view.frame.size.height);
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn addTarget:self action:@selector(saveMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setBackgroundColor:[UIColor blackColor]];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@49);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    
    [self.view bringSubviewToFront:self.progressHUD];
    self.progressHUD.delegate = self;
    
    
    //!添加轻击收拾 隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    

    
    
}
//!隐藏键盘
-(void)hideKeyBoard{
    
    [self.view endEditing:YES];
    
    
}
- (void)popNavVC:(UIButton *)btn
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ChildAccountController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }

    
}


- (void)saveMessage:(UIButton *)btn
{
    if (managementV) {
 [managementV saveChangeMessage];
        
    }
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (void)accpetToSendnickName:(NSString *)nickName status:(NSString *)status firstOpenFlag:(NSString *)firstOpenFlag merchantAccount:(NSString *)merchantAccount
{
    

    [self progressHUDShowWithString:@"操作中"];
    
    
    [HttpManager sendHttpRequestForChangeChildAccountMerchantAccountNickName:nickName status:status firstOpenFlag:firstOpenFlag merchantAccount:merchantAccount success:^(AFHTTPRequestOperation *operation, id requestObject) {
                
        NSDictionary *dict =    [NSJSONSerialization JSONObjectWithData:requestObject options:NSJSONReadingAllowFragments error:nil];

        
        if ([dict[@"code"]isEqualToString:@"000"]) {

            [self progressHUDHiddenTipSuccessWithString:@"操作成功"];
            
        }else{
            
            [self alertViewWithTitle:@"操作失败" message:[dict objectForKey:ERRORMESSAGE]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
