//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"

@class HZAreaPickerView;

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

//编辑结束
-(void)viewEditorOver;

@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;

- (void)showInView:(UIView *)view;
- (void)cancelPicker;


//!设置颜色
-(void)setColor;

//!清除颜色
-(void)setClearColor;

@end
