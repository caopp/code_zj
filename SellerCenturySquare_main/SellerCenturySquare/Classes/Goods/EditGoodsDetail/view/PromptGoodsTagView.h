//
//  PromptGoodsTagView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromptGoodsTagDelegate <NSObject>

- (void)PromptGoodsTagaddTag;

@end
@interface PromptGoodsTagView : UIView

@property (nonatomic ,assign)id<PromptGoodsTagDelegate>delegate;


@end
