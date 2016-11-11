//
//  ChildListModel.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildListModel : NSObject


@property (nonatomic ,strong) NSString *createBy;
//创建日期
@property (nonatomic ,strong) NSString *createDate;
@property (nonatomic ,strong) NSString *delFlag;
//是否开启
@property (nonatomic ,strong) NSString *enableFalg;
//是否需要首次开启
@property (nonatomic ,strong) NSString *firstOpenFlag;
//序号
@property (nonatomic ,strong) NSString *id;
//是否是主账号
@property (nonatomic ,strong) NSString *isMaster;
//手机账号
@property (nonatomic ,strong) NSString *merchantAccount;
//商家名称
@property (nonatomic ,strong) NSString *merchantName;
//商家拌面
@property (nonatomic ,strong) NSString *merchantNo;
//账号昵称
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic ,strong) NSString *pageNo;
@property (nonatomic ,strong) NSString *pageSize;
@property (nonatomic ,strong) NSString *passwd;
@property (nonatomic ,strong) NSString *startRowNum;

@end

