//
//  ZJModifyView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleButton.h"

@protocol ZJModifyViewDelegate <NSObject>

- (void)ModifyClickBtn:(StyleButton *)btn;
@end

@interface ZJModifyView : UIView


@property(nonatomic,assign)id<ZJModifyViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame  andWith:(NSArray *)titleArr;

@end
