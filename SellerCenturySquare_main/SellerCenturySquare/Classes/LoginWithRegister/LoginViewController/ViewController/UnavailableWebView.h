//
//  UnavailableWebView.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnavailableWebView : UIView
@property (strong, nonatomic) IBOutlet UIWebView *alertWebView;
@property(strong,nonatomic)NSString *htmlStr;

@end
