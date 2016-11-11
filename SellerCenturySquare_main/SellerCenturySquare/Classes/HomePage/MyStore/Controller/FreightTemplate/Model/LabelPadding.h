//
//  LabelPadding.h
//  button自适应高度
//
//  Created by 张晓旭 on 16/4/16.
//  Copyright © 2016年 张晓旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelPadding : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
