//
//  CSPLetterDetailViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeStationDTO.h"

@interface CSPLetterDetailViewController : BaseViewController

@property (nonatomic,strong)NoticeStationDTO *noticeStationDTO;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textImgBottomConstraint;

@end
