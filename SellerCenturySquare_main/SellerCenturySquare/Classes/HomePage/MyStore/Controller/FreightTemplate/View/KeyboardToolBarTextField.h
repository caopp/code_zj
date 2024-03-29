//
//  KeyboardToolBarTextField.h
//  键盘显示问题
//
//  Created by 张晓旭 on 16/4/12.
//  Copyright © 2016年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardToolBarTextField : UIToolbar
/// 使用该方法给UITextField注册使用KeyboardToolBar
/// @param textField 需要注册的UITextField
+ (void)registerKeyboardToolBar:(UITextField *)textField;

/// 不想让UITextField使用KeyboardToolBar的时候
/// 强烈建议使用该方法给UITextField移除KeyboardToolBar
/// @param textField 需要移除的UITextField
+ (void)unregisterKeyboardToolBar:(UITextField *)textField;

/// 如果嫌一个一个给UITextField移除KeyboardToolBar麻烦
/// 使用这个方法一次性将所有的UITextField移除KeyboardToolBar
+ (void)unregisterAllKeyboardToolBar;


@end
