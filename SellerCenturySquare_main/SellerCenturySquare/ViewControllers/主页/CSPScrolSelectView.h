//
//  CSPScrolSelectView.h
//  BuyerCenturySquare
//
//  Created by Edwin on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

@protocol CSPScorllViewDelegate <NSObject>

-(void)selectButtonClicked:(UIButton *)sender;

@end

#import <UIKit/UIKit.h>

@interface CSPScrolSelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonClicked:(UIButton *)sender;
@property (nonatomic ,assign)id<CSPScorllViewDelegate>delegate;

@end
