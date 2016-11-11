//
//  ProcessButton.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/2/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessButton : UIButton
@property (nonatomic ,strong)UIColor *typeColor;
@property (nonatomic ,strong)UIColor *backColor;
@property (nonatomic ,copy)NSString *typeImage;
- (instancetype)initWithFrame:(CGRect)frame  andTitle:(NSString *)title;
@end
