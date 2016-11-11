//
//  FeedbackTypePickerView.h
//  CustomerCenturySquare
//
//  Created by 张晓旭 on 16/7/7.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackModel;
typedef void(^FeedbackTypePickerBlock) (NSString *str);

@interface FeedbackTypePickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *feedbackPickerView;

@property (nonatomic,strong)FeedbackTypePickerBlock feedTypePickerBlock;

@end
