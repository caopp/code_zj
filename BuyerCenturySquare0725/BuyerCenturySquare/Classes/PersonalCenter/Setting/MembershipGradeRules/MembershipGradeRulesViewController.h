//
//  MembershipGradeRulesViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/2.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MembershipGradeRulesViewControllerDelegate <NSObject>

-(void)clearRulesOfMembershipGradeRecordCache;




@end

@interface MembershipGradeRulesViewController : UIViewController
@property(nonatomic,weak)id<MembershipGradeRulesViewControllerDelegate>delegate;
@property(nonatomic,strong)UIWebView *webView;
@end
