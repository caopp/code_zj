//
//  PurchaseController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/1/8.
//  Copyright © 2016年 pactera. All rights reserved.
// !采购商详情(从站内信过来的)

#import "PurchaseController.h"
#import "ConversationWindowViewController.h"

@interface PurchaseController ()

@end

@implementation PurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{

    
    self.navigationController.navigationBarHidden = YES;

    [HttpManager fromMessageToPurchase:self.webView withMemberNo:self.memberNo];
    
    
    
    //11.询单对话
    [self.bridge registerHandler:@"chat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        DebugLog(@"%@", data);
        
        if (data && ![data[@"chatAccount"] isEqualToString:@"<null>"] && ![data[@"nickName"] isEqualToString:@"<null>"]) {
            
            NSString *name =data[@"nickName"];
            
            NSString *JID = data[@"chatAccount"];
            
            //NSString *memberNo = IMInfo[@"memberNo"];
            
            ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:data[@"memberNo"]];

            
            
            [self.navigationController pushViewController:IMVC animated:YES];

        }
        
        
    }];
    
    
    //9.拨打电话
    [self.bridge registerHandler:@"phoneCalls" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSString *num = [NSString stringWithFormat:@"tel://%@",data[@"telephoneNum"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
        
    }];


}

- (void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    
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
