//
//  CSPMangeAdressViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "ConsigneeDTO.h"



@protocol CSPMangeAddressViewControllerDelegate <NSObject>

-(void)didClickBackButtonItemAction;

@end

@interface CSPMangeAddressViewController : BaseViewController


@property (nonatomic,assign)CSPManageAddress manageAddress;

@property (nonatomic,strong)ConsigneeDTO *consigneeDTO;


@property (nonatomic,assign)BOOL isJoinRootVC;

@property (weak,nonatomic)id <CSPMangeAddressViewControllerDelegate>delegate;

@end
