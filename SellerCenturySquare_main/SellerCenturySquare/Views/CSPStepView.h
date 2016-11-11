//
//  CSPStepView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

typedef NS_ENUM(NSInteger, changeType) {
    
    changeMin = 0,
    changeMax = 1,
    changePrice = 2
};

@interface CSPStepView : CSPBaseCustomView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *stepMinPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *stepMaxPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

/**
 *  分割线
 */
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic,copy)void (^changeStepPriceBlock)(changeType type);

@property (nonatomic,copy)void (^addStepPriceBlock)();

@property (nonatomic,copy)void (^deleteStepPriceBlock)();


- (IBAction)deleteButtonClick:(id)sender;

- (IBAction)addButtonClick:(id)sender;

@end
