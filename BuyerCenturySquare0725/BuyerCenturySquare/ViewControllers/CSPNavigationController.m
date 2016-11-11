//
//  CSPNavigationController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPNavigationController.h"

@interface CSPNavigationController ()

@end

@implementation CSPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow* shadow = [[NSShadow alloc]init];
    
    shadow.shadowColor = [UIColor clearColor];
    
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary* attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]};
    
    self.navigationBar.titleTextAttributes = attributes;
    
    [self.navigationBar setTintColor:LGNOClickColor];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    
//    UIImage *image = [UIImage imageNamed:@"whiteLine.png"];
//    [self.navigationBar setShadowImage:image];
    
    //设置导航栏线体的颜色
    UILabel *navLineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
    navLineLabel.backgroundColor = LGNOClickColor;
    [self.navigationBar addSubview:navLineLabel];
    
    
    
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
}




@end
