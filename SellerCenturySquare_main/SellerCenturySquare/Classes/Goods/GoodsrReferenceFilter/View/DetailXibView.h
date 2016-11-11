//
//  DetailXibView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailXibViewDelegate <NSObject>
//设置眼睛，全选或不适全选

-(void)setEyeButtonAction:(UIButton *)eyeButton;

@end

@interface DetailXibView : UIView

@property (weak, nonatomic) IBOutlet UILabel *setLabel;

@property (weak, nonatomic) IBOutlet UILabel *setOkLabel;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak,nonatomic)id<DetailXibViewDelegate>delegate;

- (IBAction)didClickEyeButtonAction:(id)sender;

@end
