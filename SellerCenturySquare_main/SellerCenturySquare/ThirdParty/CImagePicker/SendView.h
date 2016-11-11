//
//  SendView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendViewDelegate <NSObject>

-(void)didClickSendViewAction;
-(void)didClickPreviewButtonAction;

@end


@interface SendView : UIView


@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) IBOutlet UIButton *previewButton;

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *showBtnLabel;

@property (nonatomic,weak)id<SendViewDelegate>delegate;

@property (nonatomic ,assign)BOOL isBusiness;

@end
