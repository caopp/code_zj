//
//  InformationApplyViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/25.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InformationApplyViewControllerDelegate <NSObject>

-(void)removePersonalInformationRecordsCache;

@end


@interface InformationApplyViewController : UIViewController

@property(nonatomic,weak)id<InformationApplyViewControllerDelegate>delegate;

@property(nonatomic,strong)UIWebView *webView;
@end
