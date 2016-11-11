//
//  AddressTextField.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>       

@interface AddressTextField : UITextField
@property (nonatomic,strong)UIButton *deleteButton;
- (void)changeTextViewAlpha:(CGFloat)alpha;
- (void)changeTextLineAlpha:(CGFloat)alpha;


@end
