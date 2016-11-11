//
//  CSPNavigationController.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPNavigationController.h"

@interface CSPNavigationController ()

@end

@implementation CSPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSArray *list=self.navigationBar.subviews;
    
    for (id obj in list) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageView=(UIImageView *)obj;
            
            NSArray *list2=imageView.subviews;
            
            for (id obj2 in list2) {
                
                if ([obj2 isKindOfClass:[UIImageView class]]) {
                    
                    UIImageView *imageView2=(UIImageView *)obj2;
                    
                    imageView2.hidden = YES;
                }
            }
        }
    }

    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary* attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]};
    
    
    self.navigationBar.titleTextAttributes = attributes;
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    
    UIImage *image = [UIImage imageNamed:@"whiteLine.png"];
    
    [self.navigationBar setShadowImage:image];
    
    [self setNeedsStatusBarAppearanceUpdate];
}


@end
