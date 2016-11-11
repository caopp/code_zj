//
//  AllFreightTemplateView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AllFreightTemplateViewDelegate <NSObject>
//进行页面跳转
-(void)jumpNewFreightTemplatePage;

@end

@interface AllFreightTemplateView : UIView

@property (weak,nonatomic)id<AllFreightTemplateViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame nav:(UINavigationController *)nav;


@end
