//
//  DetailReferenceViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

#import "GoodReferenceDTO.h"


@interface DetailReferenceViewController : BaseViewController
//接受数据
@property (nonatomic,strong)GoodReferenceDTO *goodReference;


@property (weak, nonatomic) IBOutlet UILabel *showNoSelecedImage;

@end
