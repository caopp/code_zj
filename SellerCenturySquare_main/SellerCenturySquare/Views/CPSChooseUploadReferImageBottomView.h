//
//  CPSChooseUploadReferImageBottomView.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CPSChooseUploadReferImageBottomView : CSPBaseCustomView

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@property (weak, nonatomic) IBOutlet UIView *tipLineView;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (nonatomic,copy)void (^uploadBlock)();

@property (nonatomic,copy)void (^deleteBlock)();

//!选中全部
@property (nonatomic,copy)void (^selectAllBlock)(BOOL selectStatus) ;


- (IBAction)deleteButtonClick:(id)sender;


- (IBAction)uploadButtonClick:(id)sender;


@end
