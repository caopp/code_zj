//
//  CustomTextField.h
//  CPTextViewPlaceholderDemo
//
//  Created by qingsong on 13-9-27.
//  Copyright (c) 2013年 Cassius Pacheco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

- (void)changeTextViewAlpha:(CGFloat)alpha;
- (void)changeTextLineAlpha:(CGFloat)alpha;
@property (nonatomic, strong) UIView *view;

@end
