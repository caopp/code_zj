//
//  StoreTagLisrtModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@class StoreTagModel;

@interface StoreTagLisrtModel : BasicDTO

/**
 *
 */
@property(nonatomic,strong)NSMutableArray *storeTagDTOList;

@property(nonatomic,strong)NSMutableArray *storeTagList;




//模型
@property (strong,nonatomic)StoreTagModel *storeTagModel;

//标签分类名称
@property (strong,nonatomic) NSString *labelCategory;



//保other新数组
@property (nonatomic,strong)NSMutableArray *otherStoreTagList;
@property(nonatomic,strong)NSMutableArray *otherTagList;




@end
