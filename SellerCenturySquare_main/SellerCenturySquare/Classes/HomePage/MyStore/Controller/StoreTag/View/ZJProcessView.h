//
//  ZJProcessView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessButton.h"
@protocol ZJProcessViewDelegate <NSObject>

- (void)ProcessClickBtn:(ProcessButton *)btn;
@end

@interface ZJProcessView : UIView
@property(nonatomic,assign)id<ZJProcessViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame  andWith:(NSArray *)titleArr;
@end
