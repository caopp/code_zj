//
//  CSPGenerSettingTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGenerSettingTableViewController.h"
#import "CSPBaseTableViewCell.h"
#import "SDImageCache.h"
#import "GetAppVersionDTO.h"

@interface CSPGenerSettingTableViewController ()<UIAlertViewDelegate>

{
    GetAppVersionDTO *getAppVersionDTO_;
    
}
@property (nonatomic,strong) GetAppVersionDTO *getAppVersionDTO;

@end

@implementation CSPGenerSettingTableViewController
@synthesize getAppVersionDTO= getAppVersionDTO_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用";
    [self addCustombackButtonItem];
    NSString *userType = @"2";
    NSString *systemType = @"1";

    
    [HttpManager sendHttpRequestForGetAppVersion:userType systemType:systemType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                self.getAppVersionDTO = [[GetAppVersionDTO alloc] init] ;
                [self.getAppVersionDTO setDictFrom:[dic objectForKey:@"data"]];
            }
        }else{
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPBaseTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    
    if (!otherCell) {
        
        otherCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, (44-11)/2, 150, 11)];
 
    title.textColor = HEX_COLOR(0x666666FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont fontWithName:@"SourceHanSansCN-Light" size:11];
    [otherCell addSubview:title];
    
    UILabel *integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150-15, (44-14)/2, 150, 14)];
    integrationLabel.textColor = HEX_COLOR(0x666666FF);
    integrationLabel.textAlignment = NSTextAlignmentRight;
    integrationLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Normal" size:14];
   
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-8-15,(45-12)/2, 8, 12)];
    arrowImageView.image = [UIImage imageNamed:@"10_设置_进入.png"];
    
    
    if (indexPath.row == 0) {
        title.text = @"清除缓存";
        [otherCell addSubview:arrowImageView];
    }else{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

        title.text = [NSString stringWithFormat:@"版本号：%@",app_Version];
        if ([app_Version isEqualToString:self.getAppVersionDTO.version]) {
            integrationLabel.text = @"已是最新版";
        }else{
            integrationLabel.text = @"有新版本可更新";
        }
        
        [otherCell addSubview:integrationLabel];
    }
    
    return otherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定清除缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        

    }
}

#pragma mark--
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (0 == buttonIndex) {
        /**
         *  取消按钮
         */
    }else{
        
        [self clearUp];
    }
}

- (void)clearUp{
    
//    [[SDImageCache sharedImageCache] getSize]; 
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
        
        /**
         *  clear up completed.
         */
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"清除缓存已完成" duration:2 position:@"center"];
    }];
}

@end
