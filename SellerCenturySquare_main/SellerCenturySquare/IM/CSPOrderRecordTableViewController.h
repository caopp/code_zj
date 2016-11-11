//
//  CSPOrderRecordTableViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface CSPOrderRecordTableViewController : BaseTableViewController

@property (nonatomic,copy)NSString *memberNo;
@property(nonatomic,copy) void (^reOrderSendBlock)(NSDictionary *dic);
@end
