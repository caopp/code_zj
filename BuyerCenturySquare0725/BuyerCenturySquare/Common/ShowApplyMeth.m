//
//  ShowApplyMeth.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ShowApplyMeth.h"
#import "CSPApplyEditeViewController.h"
#import "CSPApplyDataTableViewController.h"
#import "MBProgressHUD.h"
@implementation ShowApplyMeth
/*
 *验证申请资料是否已经填写
 */
-(void)verApplyCode:(UIViewController *)controller{
    
    [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    [HttpManager sendHttpRequestForVerApplyInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSString *strFlag = [[dic objectForKey:@"data"] objectForKey:@"flag"];
            
            if ([strFlag intValue]) {
                
                NSString *strid = [[dic objectForKey:@"data"] objectForKey:@"id"];
                
                NSString *status = [[dic objectForKey:@"data"] objectForKey:@"status"];
                
                NSString *type = [[dic objectForKey:@"data"] objectForKey:@"type"];
                
                if ([status intValue]==2&&[type intValue] == 1) {
                    [self getApplyData:controller withApplyId:strid];
                }else {
                    [self showApplyDataTable:controller withApplyId:strid withType:type];
                }
                
            }else {
                CSPApplyEditeViewController *cspApplyEdit = [[CSPApplyEditeViewController alloc] init];
                cspApplyEdit.firstFlag = YES;
                [controller.navigationController  pushViewController:cspApplyEdit animated:YES];
            }
        }
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
    }];
    
}
-(void)getApplyData:(UIViewController *)control withApplyId:(NSString *)sid{
    [MemberInfoDTO sharedInstance].applyid = sid;
    [HttpManager sendHttpRequestForGetApplyInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            UserApplyInfo *UserDTO = [[UserApplyInfo alloc]init];
            [UserDTO setDictFrom:[dic objectForKey:@"data"]];
            CSPApplyEditeViewController *cspApplyEdit = [[CSPApplyEditeViewController alloc] init];
            cspApplyEdit.applyDefault = UserDTO;
            cspApplyEdit.noPass = YES;
            cspApplyEdit.firstFlag = YES;
            [control.navigationController  pushViewController:cspApplyEdit animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)showApplyDataTable:(UIViewController *)controller withApplyId:(NSString *)sid withType:(NSString *)type{
    
    [MemberInfoDTO sharedInstance].applyid  = sid;
    
    CSPApplyDataTableViewController *cspApply = [[CSPApplyDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
    cspApply.type = type;
    [controller.navigationController pushViewController:cspApply animated:YES];
}
@end
