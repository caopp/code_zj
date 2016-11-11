//
//  CSPRecommendDetailViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendRecordDTO.h"
#import "GetRecommendRecordDetailsListDTO.h"

@interface CSPRecommendDetailViewController : BaseViewController
@property (nonatomic,strong) RecommendRecordDTO *recommendRecordDTO;
@property (nonatomic,strong) GetRecommendRecordDetailsListDTO *getRecommendRecordDetailsListDTO;
@end
