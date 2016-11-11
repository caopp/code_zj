/***************************************************************************
 
Toast+UIView.h
Toast
Version 2.0

Copyright (c) 2013 Charles Scalesse.
 
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
***************************************************************************/

//! 提示的view
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+UIColor.h"

#define toastViewTag 90909090

#define grayViewTag 90909091

/**
 *  设置登录显示框中的线条和Placeholder的颜色
 */
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条颜色
#define LGClickborderAlpha 0.7;

@interface UIView (Toast)

// each makeToast method creates a view and displays it as toast

/**
 *  需要的方法
 *
 *  @param message 那边需要的方法
 */
-(void)makeMessage:(NSString *)message duration:(CGFloat)interval position:(id)position;



- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
