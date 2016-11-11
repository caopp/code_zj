//
//  GoodsAlllTagDTO.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicDTO.h"

@interface GoodsAlllTagDTO : BasicDTO
/**
 *  固定标签集合
 */
@property (nonatomic ,strong) NSMutableArray *fixedArr;

/**
 *  临时标签集合
 */
@property (nonatomic ,strong) NSMutableArray *otherArr;

@end

/**
 *  固定标签的集合
 */
@interface FixedTagDTO: BasicDTO


/**
 *  标签分类名称
 */
@property (nonatomic ,copy) NSString *labelCategory;
/**
 *  标签集合
 */
@property (nonatomic ,strong) NSMutableArray *listArr;

@end

/**
 *  标签集合
 */
@interface ListTagDTO : BasicDTO

/**
 *  标签名称
 */
@property (nonatomic ,copy) NSString *labelName;
/**
 *  标签id
 */
@property (nonatomic ,strong) NSNumber *ids;

/**
 *  0选中1未选中
 */
@property (nonatomic ,strong) NSNumber *flag;

@end

//@interface otheListTagDTO : BasicDTO
//
//@property (nonatomic ,copy) NSString *labelCategory;
//@property (nonatomic ,strong) NSMutableArray *otherListArr;
//
//@end
