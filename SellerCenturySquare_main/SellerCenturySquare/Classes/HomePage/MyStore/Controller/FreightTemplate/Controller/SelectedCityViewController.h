//
//  SelectedCityViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"



typedef void (^SelectedAreaArrBlock)(NSString *strId,NSString *nameStr,NSArray  *modelArr);

@interface SelectedCityViewController : BaseViewController

@property (nonatomic,copy)SelectedAreaArrBlock selectedAllAreas;

//总共获取ID重量
@property(nonatomic,weak)NSMutableArray *cityIDArr;
//总共获取ID件数
@property(nonatomic,strong)NSMutableArray *cityCoiuntIDArr;

//每个cell对应获取的ID
@property(nonatomic,strong)NSString *cellCityID;

//获取的件数对应的cellID
@property(nonatomic,strong)NSString *cellCountCityID;

//类型
@property (nonatomic,strong)NSString *type;


@end
