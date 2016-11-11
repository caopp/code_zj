//
//  FreightplateMailView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FreightplateMailViewDelegate  <NSObject>

-(void)selectedBtn:(UIButton *)btn;

@end

@interface FreightplateMailView : UIView

@property (weak,nonatomic)id<FreightplateMailViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;


@end
