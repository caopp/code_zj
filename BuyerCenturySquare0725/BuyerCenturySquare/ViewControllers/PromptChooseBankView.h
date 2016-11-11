//
//  PromptChooseBankView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromptChooseBankDelegate <NSObject>
- (void)PromptChooseDeleBankView:(UIView *)bankView;
- (void)promptChoosebankChooseBankView:(UIView *)bankView bankName:(NSString *)name;

@end
@interface PromptChooseBankView : UIView 

@property (nonatomic ,assign) id<PromptChooseBankDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame bankNames:(NSArray *)arr;


@end

