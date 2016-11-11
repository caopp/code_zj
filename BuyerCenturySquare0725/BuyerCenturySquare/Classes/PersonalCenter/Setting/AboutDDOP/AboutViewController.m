//
//  AboutViewController.m
//  BuyerCenter
//
//  Created by 左键视觉 on 15/10/23.
//  Copyright © 2015年 左键视觉. All rights reserved.
//

#import "AboutViewController.h"
#import "CustomBarButtonItem.h"
#import "GuideViewController.h"
#import "ServiceViewController.h"
#import "CCWebViewController.h"

@interface AboutViewController ()<aboutUsDeleagte>

{
    BOOL isRule;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    isRule = YES;
    self.title = NSLocalizedString(@"aboutUs", "关于叮咚欧品");
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];

    [self addCustombackButtonItem];

    
    // !顶部的view
    AboutsView *aboutView = [[[NSBundle mainBundle]loadNibNamed:@"AboutsView" owner:nil options:nil]lastObject];
    aboutView.delegate = self;
    [aboutView setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];
     aboutView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:aboutView];

    
//    //底部的label所在的view
//    CGFloat bottmViewHight = 105;
//    if ([UIScreen mainScreen].bounds.size.height <=480) {
//        
//        bottmViewHight =75;
//    }
//    
//    //底部的label所在的view
//    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-bottmViewHight, SCREEN_WIDTH, bottmViewHight)];
//    [bottomView setBackgroundColor:[UIColor colorWithHexValue:0xeeeeee alpha:1]];
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

/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
}

/**
 *  返回按钮
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];


}


#pragma mark 服务规则事件
-(void)serviceBtnClick{
    
    
    CCWebViewController  *webView = [[CCWebViewController alloc]init];
    webView.isRule = isRule;
    webView.file = [HttpManager serviceRequestWebView];
    [self.navigationController pushViewController:webView animated:YES];
    

    
//    ServiceViewController *vc = [[ServiceViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
#pragma mark 引导页事件
-(void)guideBtnClick{
    
    
    GuideViewController *guideVC = [[GuideViewController alloc]init];
    guideVC.isFromAbout = YES;
    guideVC.changeVCBlcok = ^(){

        //!选中商家列表
        [self.rdv_tabBarController setSelectedIndex:0];

        [self.navigationController popToRootViewControllerAnimated:YES];
        
    };

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
