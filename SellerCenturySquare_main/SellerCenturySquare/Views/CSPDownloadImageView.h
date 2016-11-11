//
//  CSPDownloadImageView.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPDownloadImageView : CSPBaseCustomView
@property (weak, nonatomic) IBOutlet UILabel *windowImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadObjectiveImageButton;
- (IBAction)downLoadObjectiveImageButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *objectiveImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadReferImageButton;

- (IBAction)downLoadReferImageButtonClick:(id)sender;

- (IBAction)downLoadButtonClick:(id)sender;

@property (nonatomic,copy)void (^downloadObjectiveImageBlock)();

@property (nonatomic,copy)void (^downLoadReferImageBlock)();

@property (nonatomic,copy)void (^downLoadBlock)();



@end
