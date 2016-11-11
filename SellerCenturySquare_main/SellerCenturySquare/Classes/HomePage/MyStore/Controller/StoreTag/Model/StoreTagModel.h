//
//  StoreTagModel.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface StoreTagModel : BasicDTO

//标签id
@property (strong,nonatomic) NSString *Id;
//0选中1未选中
@property (strong,nonatomic) NSString *flag;
//标签名称
@property (strong,nonatomic) NSString *labelName;




@end
