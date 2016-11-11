//
//  PersonIofoTextField.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/8/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonIofoTextField : UITextField
- (void)changeTextViewAlpha:(CGFloat)alpha;
- (void)changeTextLineAlpha:(CGFloat)alpha;
@property(nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,assign)NSIndexPath *text_row;

@end
