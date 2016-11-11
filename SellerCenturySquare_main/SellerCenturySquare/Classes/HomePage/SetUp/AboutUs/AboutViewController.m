//
//  AboutViewController.m
//  BuyerCenter
//
//  Created by 左键视觉 on 15/10/23.
//  Copyright © 2015年 左键视觉. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+UIColor.h"
#import "GuideViewController.h"
#import "ServiceViewController.h"
#import "PrepaiduUpgradeViewController.h"
@interface AboutViewController ()<aboutUsDeleagte>
{
    PrepaiduUpgradeViewController *prepaiduUpgrade;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

  
    self.title = NSLocalizedString(@"aboutUs", "关于叮咚管家");
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];

    [self customBackBarButton];
    
    
    // !顶部的view
    AboutsView *aboutView = [[[NSBundle mainBundle]loadNibNamed:@"AboutsView" owner:self options:nil]lastObject];
    aboutView.delegate = self;
    [aboutView setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];
     aboutView.frame = CGRectMake(0, 0, SCREEN_WIDTH, aboutView.frame.size.height);

    [self.view addSubview:aboutView];

    
    
    //底部的label所在的view
    CGFloat bottmViewHight = 105;
    if (SCREEN_HIGHT <=480) {
        
        bottmViewHight =75;
    }
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HIGHT-64-bottmViewHight, SCREEN_WIDTH, bottmViewHight)];
    [bottomView setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];
//    [self.view addSubview:bottomView];
    
    
    //Copyright©2015
//    UILabel *copyRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 20)];
//    copyRightLabel.text = @"Copyright©2015";
//    [copyRightLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
//    [copyRightLabel setTextAlignment:NSTextAlignmentCenter];
//    [bottomView addSubview:copyRightLabel];
//    
//    //深圳市左键视觉科技有限公司
//    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(copyRightLabel.frame), bottomView.frame.size.width, 20)];
//    companyLabel.text = NSLocalizedString(@"company", @"深圳市左键视觉科技有限公司");
//    companyLabel.font = [UIFont systemFontOfSize:12];
//    [companyLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
//    [companyLabel setTextAlignment:NSTextAlignmentCenter];
//    [bottomView addSubview:companyLabel];

    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = NO;

    
}

- (void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.translucent = NO;

}

- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 服务规则事件
-(void)serviceBtnClick{
    
    prepaiduUpgrade = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgrade.file = [HttpManager serviceRequestWebView];
    [self.navigationController pushViewController:prepaiduUpgrade animated:YES];
    
    
//    serviceRequestWebView
    
    
//    ServiceViewController *vc = [[ServiceViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    

}
#pragma mark 引导页事件
-(void)guideBtnClick{

    GuideViewController *guideVC = [[GuideViewController alloc]init];
    guideVC.isFromAbout = YES;
    guideVC.changeVCBlcok = ^(){
    
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    };
//    [self.navigationController pushViewController:guideVC animated:YES];
    [self presentViewController:guideVC animated:YES completion:nil];


    
    
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
