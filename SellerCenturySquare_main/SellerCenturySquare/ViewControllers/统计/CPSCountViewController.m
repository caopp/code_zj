//
//  CPSCountViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSCountViewController.h"
#import "MyUserDefault.h"

@interface CPSCountViewController ()

@end

@implementation CPSCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"统计";
    [self navigationBarSettingShow:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    
    // !如果是子账号 就提示
    if ([self isNotMatser]) {
        
        [self.view makeMessage:@"您暂无查看统计的权限" duration:2.0f position:@"center"];
        
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeSelectVc) userInfo:nil repeats:NO];
        
        
        return;
    }
}
// !当用户无权利查看时，返回上一个选择的界面
- (void)changeSelectVc{
    
    // !当前选中的tabbar是商品
    if (self.rdv_tabBarController.selectedIndex == 4) {
        
        [self.rdv_tabBarController setSelectedIndex:self.rdv_tabBarController.lastSelectedIndex];
        
        
    }
    
    
    
}


#pragma mark 判断是否是子账号
- (BOOL)isNotMatser{
    
    NSString * isMaster = [MyUserDefault JudgeUserAccount];
    
    // !(0/YES:主账户 1/NO:子账户)
    if ([isMaster isKindOfClass:[NSString class]] && isMaster != nil) {
        
        // !如果是子账号登录，则返回上一次点击index
        if ([isMaster isEqualToString:@"1"]) {
            
            return YES;
            
        }
        
        
    }
    
    return NO;
    
    
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
