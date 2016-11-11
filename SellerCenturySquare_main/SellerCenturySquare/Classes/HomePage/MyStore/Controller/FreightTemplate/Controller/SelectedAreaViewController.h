//
//  SelectedAreaViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SelectedAreaArrBlock)(NSString *strId,NSString *nameStr);
@interface SelectedAreaViewController : BaseViewController

@property (nonatomic,copy)SelectedAreaArrBlock selectedAllAreas;

@end
