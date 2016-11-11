//
//  MembershipUpgradeViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MembershipUpgradeViewControllerDelegate <NSObject>

-(void)backEliminateTheController;

-(void)jumpToPayInterfaceDic:(NSDictionary *)dic;


-(void)returnedMerchandisePage;


-(void)returnsListOfGoods;


@end

@interface MembershipUpgradeViewController : UIViewController



@property(weak,nonatomic)id<MembershipUpgradeViewControllerDelegate>delegate;
@property(nonatomic,strong)UIWebView *webView;

///跳转到根试图控制器!cg
@property(nonatomic ,assign) BOOL markRootVC;


@property (nonatomic,strong)NSString *file;
@property (nonatomic,strong)NSString *titleVC;



@end
