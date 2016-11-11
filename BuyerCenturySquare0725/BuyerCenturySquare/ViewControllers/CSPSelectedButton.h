//
//  CSPSelectedButton.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPPicInfoDTO.h"
#import "DownloadLogControl.h"


@interface CSPSelectedButton : UIButton

@property(strong,nonatomic)CSPPicInfoDTO *picInfoDTO;

@property(strong,nonatomic)DownloadLogFigure *figure;


@end
