//
//  FeedBackViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/8/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedBackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)didClickSubmitAction:(id)sender;

@end
