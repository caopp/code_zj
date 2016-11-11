//
//  TabBarController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/11/3.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "TabBarController.h"





@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
    if (self = [super init]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //商家
        MerchantListViewController * merchantListVC = [[MerchantListViewController alloc]init];
        CSPBlackNavigationController *merchantNav= [[CSPBlackNavigationController alloc]initWithRootViewController:merchantListVC];
        
        
        //商品
        CustomGoodsListViewController * goodsVC =[[CustomGoodsListViewController alloc]init];
        CSPBlackNavigationController *goodsNav = [[CSPBlackNavigationController alloc]
                                                                    initWithRootViewController:goodsVC];
        
        //商圈
        BusinessCircleController *businessCircle = [[BusinessCircleController alloc] init];
        businessCircle.selfTitle = @"商圈";

        CSPBlackNavigationController *threeNav = [[CSPBlackNavigationController alloc] initWithRootViewController:businessCircle];
        
        
        //采购车
       // CSPShoppingCartViewController *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
        NewsViewController *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
        CSPBlackNavigationController *thirdNavigationController = [[CSPBlackNavigationController alloc]
                                                                   initWithRootViewController:thirdViewController];
        
        //个人中心
        CSPPersonCenterMainViewController *forthViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPersonCenterMainViewController"];
        
        CSPBlackNavigationController *forthNavigationController = [[CSPBlackNavigationController alloc]
                                                                   initWithRootViewController:forthViewController];
        
        [self addChildViewController:forthNavigationController];
        
        [self setViewControllers:@[merchantNav, goodsNav,
                                   thirdNavigationController,threeNav,forthNavigationController]];
        
        [self customizeTabBarForController:self];
        
        self.selectedIndex  = 1;
        
      
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addRDVTabBarNotice];
    
    
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"midden",@"three",@"five"];
    NSArray *tabBarItemTitles = @[@"商家", @"商品",@"叮咚",@"商圈", @"我的"];
    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor blackColor];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        //        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        [item setTitle:[NSString stringWithFormat:@"%@",[tabBarItemTitles objectAtIndex:index]]];
        
        index++;
    }
}



- (void)addRDVTabBarNotice {
    
    //注册采购车小红点显示事件
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCart) name:addCartNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCart) name:clickCartNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNews:) name:SHOWNEWS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewsNotice) name:addNewsNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearNewsNotice) name:clearNewsNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotice) name:addNoticeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearNotice) name:clearNoticeNotification object:nil];
    
    
//    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:3];
//    [item addTarget:self action:@selector(clickCart) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)showNews:(NSNotification *)noti{
    
    NSDictionary *dict = noti.userInfo;

    
    
    
 

    NSString *typeStr = dict[@"type"];
    
    
    NSInteger type = typeStr.integerValue;
    
    if ([dict[@"type"] isEqualToString:@"7"])
    {//商品
        
        if (self.selectedIndex ==1) {
            
        }else {
            //推送进入
            [self setTabBarHidden:NO];
            UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
            
            [nav popToRootViewControllerAnimated:YES];
            self.selectedIndex = 1;
        }
        
    }
    else if ([dict[@"type"] isEqualToString:@"8"])//商圈
    {
        if (self.selectedIndex ==3) {
            
        }else {
            //推送进入
            [self setTabBarHidden:NO];
            UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
            
            [nav popToRootViewControllerAnimated:YES];
            self.selectedIndex = 3;
        }
        
    }
    else if (type <= 5)
    {
    
    if (self.selectedIndex ==2) {
        
    }else {        
        //推送进入
        [self setTabBarHidden:NO];
        UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        
        [nav popToRootViewControllerAnimated:YES];
        self.selectedIndex = 2;
        }
    }
    else if (type == 6)
    {
        if (self.selectedIndex ==2) {
            
        }else {
            
            //推送进入
            [self setTabBarHidden:NO];
            UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
            
            [nav popToRootViewControllerAnimated:YES];
            self.selectedIndex = 2;
        }

    }
    else if (type == 9)
    {
        if (self.tabBarController.selectedIndex ==2) {
            
        }else {
            
            //推送进入
            [self setTabBarHidden:NO];
            UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
            
            [nav popToRootViewControllerAnimated:YES];
            self.selectedIndex = 2;
        }
    }

    
}
- (void)addCart {
    
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:3];
    
    [item setBadgeValue:@" "];
}

- (void)clickCart {
    
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:3];
    
    [item setBadgeValue:@""];
}

- (void)addNotice {
    
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:4];
    
    [item setBadgeValue:@" "];
}

- (void)clearNotice {
    
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:4];
    
    [item setBadgeValue:@""];
    
}
-(void)addNewsNotice{
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:2];
    
    [item setBadgeValue:@" "];
}
-(void)clearNewsNotice{
    RDVTabBarItem * item = [[[self tabBar] items] objectAtIndex:2];
    
    [item setBadgeValue:@""];
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
