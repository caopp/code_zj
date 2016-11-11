//
//  CourierView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CourierViewDelegate <NSObject>

-(void)didClickAction;

@end
@interface CourierView : UIView

@property (weak,nonatomic)id<CourierViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

//
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
//快递公司名字
@property (weak, nonatomic) IBOutlet UILabel *courierName;
//
@property (weak, nonatomic) IBOutlet UILabel *courierNum;
//快递公司单号
@property (weak, nonatomic) IBOutlet UILabel *courierCompanyNum;
//
@property (weak, nonatomic) IBOutlet UILabel *sendPeopleLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *sendNameLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@end
