//
//  RecommendReceiverDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface RecommendReceiverDTO : BasicDTO

/**
 *  会员编号
 */
@property(nonatomic,strong)NSNumber *memberNo;
/**
 *  会员昵称
 */
@property(nonatomic,copy)NSString *nickName;
/**
 *  真实姓名
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  会员账号
 */
@property(nonatomic,copy)NSString *memberAccount;
/**
 *  会员等级
 */
@property(nonatomic,strong)NSNumber *memberLevel;
/**
 *  选中
 */
@property(nonatomic,assign)BOOL selected;


@end
