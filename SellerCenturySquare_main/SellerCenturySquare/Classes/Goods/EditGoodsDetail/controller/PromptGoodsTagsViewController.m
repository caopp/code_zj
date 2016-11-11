//
//  PromptGoodsTagViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PromptGoodsTagsViewController.h"
#import "PromptGoodsTagView.h"
#import "AddMoreTagTableViewCell.h"
#import "GoodsLagViewController.h"
#import "EditGoodsViewController.h"

@interface PromptGoodsTagsViewController ()<PromptGoodsTagDelegate>

@end

@implementation PromptGoodsTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品标签";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customBackBarButton];
    
    //加载商品
    PromptGoodsTagView *promptGoodsView = (PromptGoodsTagView *)[[[NSBundle mainBundle] loadNibNamed:@"PromptGoodsTagView" owner:nil options:nil] lastObject];
    promptGoodsView.delegate = self;
    
    
    promptGoodsView.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-64);
    
    [self.view addSubview:promptGoodsView];
    
    
    
    
    
    
//
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)PromptGoodsTagaddTag
{
    
    GoodsLagViewController *goodsLagVC = [[GoodsLagViewController alloc] init];
    goodsLagVC.goodsNo = self.goodsNo;
    
    [self.navigationController pushViewController:goodsLagVC animated:YES];
    
    
}


- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[EditGoodsViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
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
