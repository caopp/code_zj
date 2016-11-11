//
//  CSPPwdModificationViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPPwdModificationViewController.h"
#import "LoginDTO.h"
@interface CSPPwdModificationViewController ()
- (IBAction)loginButtonClick:(id)sender;

@end

@implementation CSPPwdModificationViewController

-(void)viewWillAppear:(BOOL)animated
{
   

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-登录
- (IBAction)loginButtonClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [self progressHUDShowWithString:@"登录中"];
//    
//    [HttpManager sendHttpRequestForLoginWithMemberAccount:self.phoneNumber password:self.loginPassword success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self.progressHUD hide:YES];
//        
//        NSDictionary *responseDic = [self conversionWithData:responseObject];
//        
//        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
//            //操作成功
//            DebugLog(@"responseDic = %@", responseDic);
//            
//            [[LoginDTO sharedInstance]setDictFrom:[responseDic objectForKey:@"data"]];
//            
//            //保存用户名
//            NSMutableArray *historicalAccountArray = [[NSMutableArray alloc] initWithContentsOfFile:[self getHistoricalAccountListPath]];
//            
//            DebugLog(@"historicalAccountArray = %@", historicalAccountArray);
//            
//            NSArray *tmpHistoryArr = [NSArray arrayWithArray:historicalAccountArray];
//            
//            //添加账号
//            if (historicalAccountArray.count) {
//                for (NSString *account in tmpHistoryArr) {
//                    
//                    if (![account isEqualToString:self.phoneNumber]) {
//                        
//                        [historicalAccountArray addObject:self.phoneNumber];
//                    }
//                }
//            }else{
//                [historicalAccountArray addObject:self.phoneNumber];
//            }
//            
//            if (historicalAccountArray.count>3) {
//                //只保留最后3个账号
//                NSMutableArray *array = [[NSMutableArray alloc]init];
//                
//                [array addObjectsFromArray:historicalAccountArray];
//                
//                for (int i = 0; i<array.count-3; i++) {
//                    
//                    [historicalAccountArray removeObjectAtIndex:i];
//                    
//                }
//            }
//            
//            //保存
//            [historicalAccountArray writeToFile:[self getHistoricalAccountListPath] atomically:YES];
//            
//            //聊天登录
////            [[ChatManager shareInstance] connectToServer:[NSString stringWithFormat:@"%@_1", self.phoneNumberTextField.text] passWord:[[self.passwordTextField.text MD5Hash] lowercaseString]];
////            //打开聊天数据库
////            [[DeviceDBHelper sharedInstance] openDataBasePath:[NSString stringWithFormat:@"%@_1", self.phoneNumberTextField.text]];
////            
////            //更新window rootViewController
////            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
////            
////            [delegate updateRootViewController:self.tabBarController];
//            
//        }else{
//            
//            [self alertViewWithTitle:@"登录失败" message:[responseDic objectForKey:ERRORMESSAGE]];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [self tipRequestFailureWithErrorCode:error.code];
//    }];
    
}
@end
