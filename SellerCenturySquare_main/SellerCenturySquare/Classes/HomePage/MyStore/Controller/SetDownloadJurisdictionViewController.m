//
//  SetDownloadJurisdictionViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetDownloadJurisdictionViewController.h"
#import "HttpManager.h"
#import "MerchantPermissionDTO.h"
#import "GetMerchantNotAuthTipDTO.h"
#import "GetMerchantInfoDTO.h"
#import "HttpManager.h"
#import "CSPVIPUpdateViewController.h"
#import "GUAAlertView.h"
#import "UIColor+UIColor.h"
#import "MerchantsPrivilegesViewController.h"//!采购商
#import "SecondaryViewController.h"
#import "TransactionRecordsViewController.h"
#import "ThreePageViewController.h"

@interface SetDownloadJurisdictionViewController ()<UIAlertViewDelegate,SecondaryViewControllerDelegate>
{

    GUAAlertView * alertView ;
}
@property (nonatomic,assign) BOOL hasOpenLimit;
@end

@implementation SetDownloadJurisdictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hasOpenLimit = [GetMerchantInfoDTO sharedInstance].downloadLimit7;
    
    [self jurisdictionJudgement];
    
    
    [self customBackBarButton];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _levelTipsL.text = [NSString stringWithFormat:@"您的等级为V%@，达到V5后，可开启限制",[GetMerchantInfoDTO sharedInstance].level];
    [self tabbarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest
- (void)setOpenLimitRequest:(BOOL)open{
    
    NSString *openState = open?@"0":@"1";
    
    [HttpManager sendHttpRequestForGetImgDownloadSetting:openState success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            DebugLog(@"大B图片七日内下载限制设置接口  返回正常编码");
            
            _hasOpenLimit = open;
            
            [self jurisdictionJudgement];
            
        }else{
            
            DebugLog(@"大B图片七日内下载限制设置接口 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2 position:@"center"];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self.view makeMessage:@"修改失败" duration:2 position:@"center"];

        
    } ];
    
}


#pragma mark - Private Functions

//提示字符串显示或隐藏
- (void)setLevelTipsHidden:(BOOL)hide{
    
    _levelTipsL.hidden = hide;
}

//当前状态
- (void)openLimit:(BOOL)open{
    
    _openOrCloseL.text = open?@"已开启限制":@"未开启限制";
    
}

//权限状态界面更新
- (void)jurisdictionJudgement{
    
    if (_hasAuth) {
        
        if (_hasOpenLimit) {
         
            [self changeButtonTitle:@"取消限制"];
            
        }else{
            
            [self changeButtonTitle:@"开启限制"];
        }
        
        // !改变状态提示：是否已经开启限制
        [self openLimit:_hasOpenLimit];
        // !可设置等级 的提示 隐藏
        [self setLevelTipsHidden:YES];
        
        
    }else{
        
        [self changeButtonTitle:@"查看商家特权"];
        
        // !可设置等级 的提示 显示
        [self setLevelTipsHidden:NO];
        
        // !改变状态提示：是否已经开启限制
        [self openLimit:NO];
    }
    
}

- (void)changeButtonTitle:(NSString*)title{
    
    [_button setTitle:title forState:UIControlStateNormal];
    
    [_button setTitle:title forState:UIControlStateHighlighted];
    
}

- (IBAction)blackButtonClicked:(id)sender {
    
    if (_hasAuth) {
        
        NSString *title;
        NSString *msg;
        
        if (_hasOpenLimit) {
            
            title = @"取消限制后\n无交易往来的采购商将可以下载\n7日内本店更新的商品图片";
            msg = @"确定取消限制?";
            
        }else{
            
            title = @"开启限制后\n无交易往来的采购商将不可下载\n7日内本店更新的商品图片";
            msg = @"确定开启限制?";
        }
        
        alertView = [GUAAlertView alertViewWithTitle:title withTitleClor:[UIColor colorWithHex:0xeb301f alpha:1] withTitleFont:10 message:msg withMessageColor:[UIColor colorWithHex:0x666666 alpha:1] oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self setOpenLimitRequest:!_hasOpenLimit];

            
        } dismissAction:nil];
        
        [alertView show];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alertView show];

        
    }else{
        
        //查看商家特权  和h5交互
//        CSPVIPUpdateViewController *vipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPVIPUpdateViewController"];
//        
//        [self.navigationController pushViewController:vipVC animated:YES];
        
        
        ThreePageViewController *threePageVC = [[ThreePageViewController alloc]init];
        
        threePageVC.file = [HttpManager privilegesNetworkRequestWebView];
        
        [self.navigationController pushViewController:threePageVC animated:YES];
        
    }
    
    
    

}

-(void)pushTransactionRecordsVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TransactionRecordsViewController *nextVC = [storyboard instantiateViewControllerWithIdentifier:@"TransactionRecordsViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        [self setOpenLimitRequest:!_hasOpenLimit];
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
