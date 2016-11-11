//
//  AddressMessageBook.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^blockPermissions)();


@interface AddressMessageBook : NSObject
@property (nonatomic ,strong) NSMutableArray *contractsArray;

@property (nonatomic ,copy) blockPermissions blockPer;

@property (nonatomic ,copy) void (^blockPhoneName)(NSArray *);


-(void)getPhoneContracts;



@end
