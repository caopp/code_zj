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
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.title = NSLocalizedString(@"general",  @"通用");
    
    [self addCustombackButtonItem];
    
    /*
     // !现在不用判断是否是最新版本了

    NSString *userType = @"2";
    NSString *systemType = @"1";
     
    [HttpManager sendHttpRequestForGetAppVersion:userType systemType:systemType success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
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
    */
    
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
 
    title.textColor = HEX_COLOR(0x999999FF);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    [otherCell addSubview:title];
    
    UILabel *integrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150-15, (44-14)/2, 150, 14)];
    integrationLabel.textColor = HEX_COLOR(0x999999FF);
    integrationLabel.textAlignment = NSTextAlignmentRight;
    integrationLabel.font = [UIFont systemFontOfSize:14];
   

    if (indexPath.row == 0) {
        
        title.text = NSLocalizedString(@"clearMemory", @"清除缓存");
        
        otherCell.accessoryType = 1;
        
    }else{

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

        title.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"version", @"版本号："),app_Version];
        
        if ([app_Version isEqualToString:self.getAppVersionDTO.version]) {
            
            integrationLabel.text = @"";
            
        }else{
            
            integrationLabel.text = @"";
            
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
  
    
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.row == 0) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"sureClear", @"确定清除缓存吗?") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:NSLocalizedString(@"sure", @"确定"), nil];
//        [alert show];
        GUAAlertView *al=[GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:NSLocalizedString(@"sureClear", @"确定清除缓存吗?") withMessageColor:nil oKButtonTitle:NSLocalizedString(@"sure", @"确定") withOkButtonColor:nil cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            // !确定
            [self clearUp];
            
            
        } dismissAction:^{
            // !取消

            
        }];
        //2、显示
        [al show];


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
        
        [self.view makeMessage:NSLocalizedString(@"clearSuccess", @"清除缓存已完成") duration:2.0f position:@"center"];

       
        
        
    }];
    
    
}

@end
