//
//  GeneralTableViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GeneralTableViewController.h"
#import "HttpManager.h"
#import "SDImageCache.h"
#import "GUAAlertView.h"

@interface GeneralTableViewController ()<UIAlertViewDelegate>

@end

@implementation GeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    _appVersionL.text = [NSString stringWithFormat:@"版本号：%@",[self getLocalAppVersion]];

    // !不需要再请求是否是最新版本
    //    [self getLastAppVersionRequest];
    
    // !返回按钮
    [self customBackBarButton];
    

}
- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private Functions
- (void)getLastAppVersionRequest{
    
    [HttpManager sendHttpRequestForGetAppVersion:@"1" systemType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *info = [dic objectForKey:@"data"];
                
                NSString *versionFromHttp = info[@"version"];
                
                if ([versionFromHttp isEqualToString:[self getLocalAppVersion]]) {
                    
//                    _versionMsgL.text = @"已是最新版本";
                    
                }else{
                    
//                    _versionMsgL.text = @"不是最新版本！";
                }
                
                _versionMsgL.text = @"";

                
            }
            
        }else{
            
            NSLog(@" 采购商-资料接口（申请资料） 返回异常编码 errorMessage = %@",[dic objectForKey:@"errorMessage"]);
        }
        
        NSLog(@"dic = %@",dic);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSString*)getLocalAppVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
    
    
}

- (void)clearCache{
 
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    
    NSLog(@"SDImageCache 缓存大小 清除前 %ziM",size/1024/1024);
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView cancelButtonIndex]!=buttonIndex) {
        
        [self clearCache];
        
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        
        NSLog(@"SDImageCache 缓存大小 清除后 %ziM",size/1024/1024);
    }
}

#pragma mark - Table view data source
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 0.1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定清除缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
        
        
        GUAAlertView *alerView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定清除缓存吗?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self clearCache];
            
            [self.view makeMessage:@"清除缓存已完成" duration:2.0 position:@"center"];
            
            
        } dismissAction:nil];
        
        
        [alerView show];
        
        
        
    }
    
    
    
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
