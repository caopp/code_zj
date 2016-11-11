//
//  StayDeliverBtnView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StayDeliverDelegate <NSObject>

/**
 *  确认收货
 */
- (void)StayDeliverConfirmation;

@end
@interface StayDeliverBtnView : UIView

@property (weak, nonatomic) IBOutlet UIButton *confirmationDeliveryBtn;
@property (nonatomic ,assign) id<StayDeliverDelegate>delegate;

- (IBAction)selelctConfirmationDeliveryBtn:(id)sender;


@end
