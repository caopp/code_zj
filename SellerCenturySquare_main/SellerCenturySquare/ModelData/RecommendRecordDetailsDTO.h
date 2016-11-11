//
//  RecommendRecordDetailsDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface RecommendMemberDTO : BasicDTO

/**
 *  收件人编码
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  收件人姓名
 */
@property(nonatomic,copy)NSString *memberName;

@end

