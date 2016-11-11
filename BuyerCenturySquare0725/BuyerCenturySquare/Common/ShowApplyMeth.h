//
//  ShowApplyMeth.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowApplyMeth : NSObject
-(void)verApplyCode:(UIViewController *)controller;
-(void)getApplyData:(UIViewController *)control withApplyId:(NSString *)sid;
-(void)showApplyDataTable:(UIViewController *)controller withApplyId:(NSString *)sid withType:(NSString *)type;
@end
