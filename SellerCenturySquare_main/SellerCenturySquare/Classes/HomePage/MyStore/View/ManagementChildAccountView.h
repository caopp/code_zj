//
//  AddChildAccountView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManagementChildAccountDelegate <NSObject>

- (void)accpetToSendnickName:(NSString *)nickName status:(NSString *)status firstOpenFlag:(NSString *)firstOpenFlag merchantAccount:(NSString *)merchantAccount;



@end
@interface ManagementChildAccountView : UIView
/**
 * 点击每一个cell显示此View
 *
 *  @param dict 传过来的数据
 */

- (void)accpetToSendData:(NSDictionary *)dict;


@property (nonatomic ,assign) id<ManagementChildAccountDelegate>delegate;

- (void)saveChangeMessage;
@end
