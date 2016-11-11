//
//  AddressDetailViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/10.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressDetailViewControllerDelegate <NSObject>

-(void)implementProxyMethodID:(NSNumber *)ID button:(UIButton *)button;

@end

@interface AddressDetailViewController : UIViewController

@property (nonatomic,assign)CSPManageAddress manageAddress;

@property (nonatomic,strong)ConsigneeDTO *consigneeDTO;

@property (weak,nonatomic)id<AddressDetailViewControllerDelegate>delegate;
@end
