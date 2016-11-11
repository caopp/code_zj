//
//  SaveInfoView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveInfoViewDelegate <NSObject>


-(void)didClickLoginAction;
-(void)didClickForgetPasswordButtonAction;

@end



@interface SaveInfoView : UIView


@property(weak,nonatomic)id<SaveInfoViewDelegate>delegate;


@property (strong, nonatomic) IBOutlet UIView *backgroundView;



@property (strong, nonatomic) IBOutlet UILabel *lineLabel;

@property (strong, nonatomic) IBOutlet UIButton *loginButtton;

@property (strong, nonatomic) IBOutlet UIButton *forgetLoginPasswordButton;

@property (strong, nonatomic) IBOutlet UILabel *lineSecondLabel;

@property (strong, nonatomic) IBOutlet UILabel *describeLabel;






@end
