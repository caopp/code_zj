//
//  AnotherPlaceLoginAlertView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnotherPlaceLoginAlertView : UIView


@property (weak, nonatomic) IBOutlet UIView *alertCenterView;


@property (weak, nonatomic) IBOutlet UIView *alertTopView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionL;
@property (strong, nonatomic) IBOutlet UIButton *showBtn;

@property(nonatomic,copy) void (^reloginBtnBlock)();



@end
