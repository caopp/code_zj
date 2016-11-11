//
//  InitialFreighTemplateView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InitialFreighTemplateViewDelegate <NSObject>

-(void)showAllFreightTemplate;

@end

@interface InitialFreighTemplateView : UIView
//介绍说明
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
//选择运费模板按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
//选择运费模板行为
- (IBAction)didClickChooseButtonAction:(id)sender;
//设置代理
@property (nonatomic,weak)id<InitialFreighTemplateViewDelegate>delegate;

@end
