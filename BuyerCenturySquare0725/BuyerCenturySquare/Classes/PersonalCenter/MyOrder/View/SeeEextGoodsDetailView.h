//
//  SeeEextGoodsDetailView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeEextGoodsDetailView : UIView
//客服
@property (weak, nonatomic) IBOutlet UIButton *customServiceBtn;
//查看退换货详情
@property (weak, nonatomic) IBOutlet UIButton *seeExitChangeDetailBtn;
//type 0 客服 1 查看退换货详情
@property (nonatomic ,copy) void (^blockSeeExitChangeDetail)(NSString *type);

- (IBAction)selectCustomServiceBtn:(id)sender;
- (IBAction)selectSeeExitChangeDetailBtn:(id)sender;

@end
