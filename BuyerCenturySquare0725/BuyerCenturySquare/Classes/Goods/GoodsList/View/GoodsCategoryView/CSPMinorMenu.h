//
//  CSPMinorMenu.h
//  DOPNavbarMenuDemo
//
//  Created by skyxfire on 8/5/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPMinorMenu;
@protocol MinorMenuClickDelegate <NSObject>

- (void)MinorMenuClick:(NSInteger)index withCSPMinorMenu:(CSPMinorMenu *)view;

@end

@interface CSPMinorMenu : UIView

@property (nonatomic, assign) id<MinorMenuClickDelegate>delegate;

@property (nonatomic, strong) NSString * selectStructureNo;

@property (nonatomic, strong) UIButton * selectBtn;

@property (nonatomic, strong) NSString * parentStructureNo;

- (id)initWithMinorItems:(NSArray*)minorItems;

- (void)showInView:(UIView *)view belowSubview:(UIView*)subview;

- (void)dismissWithAnimation:(BOOL)animation;

- (void)setMinorItems:(NSArray *)minorItems;

@end
