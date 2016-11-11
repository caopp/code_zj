//
//  RegisteredView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisteredViewDelegate <NSObject>

-(void)goOnCompleteRegisteredAction;

@end



@interface RegisteredView : UIView

@property (strong, nonatomic) IBOutlet UIButton *goOnRegisteredButton;

@property (strong, nonatomic) IBOutlet UILabel *registeredSuccessLabel;

@property(nonatomic,weak)id<RegisteredViewDelegate>delegate;
 
@end
