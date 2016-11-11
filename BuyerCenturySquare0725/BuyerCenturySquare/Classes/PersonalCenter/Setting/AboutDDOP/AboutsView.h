//
//  AboutView.h
//  BuyerCenter
//
//  Created by 左键视觉 on 15/10/23.
//  Copyright © 2015年 左键视觉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol aboutUsDeleagte <NSObject>

-(void)serviceBtnClick;//!服务规则

-(void)guideBtnClick;// !引导页


@end

@interface AboutsView : UIView<aboutUsDeleagte>

//ddop图片
@property (weak, nonatomic) IBOutlet UIImageView *aboutImageView;

//"叮咚欧品"
@property (weak, nonatomic) IBOutlet UILabel *appNamLabel;

//版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

//描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

// !服务规则
@property (weak, nonatomic) IBOutlet UIButton *serviceRuleBtn;

// !观看引导页
@property (weak, nonatomic) IBOutlet UIButton *guideBtn;


@property(nonatomic,assign)id<aboutUsDeleagte>   delegate;

//!图片顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;

@end
