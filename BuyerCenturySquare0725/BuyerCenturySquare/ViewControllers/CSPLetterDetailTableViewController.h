//
//  CSPLetterDetailTableViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
typedef void (^ReturnTextBlock)();
@interface CSPLetterDetailTableViewController : BaseTableViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;
@end
