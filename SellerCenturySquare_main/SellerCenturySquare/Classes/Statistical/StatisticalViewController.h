//
//  StatisticalViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface StatisticalViewController : UIViewController

@property (nonatomic,strong)UIWebView *webView;

/**
 *  标题
 */
@property (nonatomic ,copy) NSString *selfTitle;

/**
 *  跳转到控制传的URL
 */
@property (nonatomic ,copy) NSString *requestUrl;

@property (nonatomic ,copy) NSString *markHideNav;




@end
