//
//  InviteAddressBook.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/5/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteAddressBook : NSObject

//!通讯录联系人字典
@property(nonatomic,strong)NSMutableDictionary * contactInfoDic;

//!获取排好序的通讯录字典
-(void)getSortContactDicWithAuthor:(void (^)(NSMutableDictionary * contactInfoDic))withAuthor  noAuthor:(void (^)())noAuhor;


//获取联系人权限
- (BOOL)getAuthorization;




@end
