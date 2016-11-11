//
//  WholesaleAndRetailView.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WholesaleAndRetailView : UIView
//不选择包邮
@property (weak, nonatomic) IBOutlet UILabel *selectedUnPackage;

//选择包邮
@property (weak, nonatomic) IBOutlet UILabel *unselectedPackage;

@end
