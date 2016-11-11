//
//  AppDelegate.h
//  SellerCenturySquare
//
//  Created by skyxfire on 7/1/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)RDVTabBarController * tabBarController;
@property(nonatomic,assign)BOOL _unavailableWeb;
@property(nonatomic,assign)BOOL showThridKeyboard;

- (void)updateRootViewController:(id)rootViewController;

@end

