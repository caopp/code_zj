//
//  MerchantsInTextField.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/29.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsInTextField : UITextField

@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;

@end
