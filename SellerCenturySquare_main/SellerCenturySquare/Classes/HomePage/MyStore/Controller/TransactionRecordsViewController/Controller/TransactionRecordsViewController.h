//
//  TransactionRecordsViewController.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, eRefreshType){
    eRefreshTypeDefine=0,
    eRefreshTypeProgress=1
};
@interface TransactionRecordsViewController : BaseViewController
@property (nonatomic,assign)eRefreshType type;

@end
