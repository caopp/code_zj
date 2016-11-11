//
//  CSPModifyPriceView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"
#import "AFFNumericKeyboard.h"
#import "Toast+UIView.h"

@protocol CSPModifyPriceViewDelegate <NSObject>

- (void)cspModifyPricechangeOrderTotal:(UIView*)priceView;


@end

@interface CSPModifyPriceView : CSPBaseCustomView<AFFNumericKeyboardDelegate ,CSPModifyPriceViewDelegate>
{
    CGFloat contentViewOrigin;
}

@property (nonatomic ,assign)Rect rectOld;
@property (nonatomic ,assign)id <CSPModifyPriceViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalTotalAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amoutTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic,copy)void (^confirmBlock)();

/**
 *  block 列表请求  delegate详情请求 必传
 */
//@optional
@property (nonatomic ,strong)NSString *requestType;



- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)confirmButtonClick:(id)sender;

@end
