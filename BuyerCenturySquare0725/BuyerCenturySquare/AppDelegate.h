//
//  AppDelegate.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) CSPNavigationController *nav;
@property(nonatomic,assign)BOOL _unavailableWeb;
@property(nonatomic,assign)BOOL showThridKeyboard;
+ (AppDelegate *)currentAppDelegate;
- (BOOL)isWifiReach;
-(void)updateRootViewController;
-(void)intoNextWindow;

@end

