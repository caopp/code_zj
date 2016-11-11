//
//  CSPProtocalViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CSPProtocalViewControllerDelegate <NSObject>

- (void)acceptProtocal;

@end

@interface CSPProtocalViewController : BaseViewController

@property (nonatomic, assign)id<CSPProtocalViewControllerDelegate> delegate;
@property (nonatomic,strong)NSString *file;

@end
