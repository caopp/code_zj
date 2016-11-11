//
//  AddChildAccountView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddChildAccountViewDelegate <NSObject>

- (void)AddChildAccountNickName:(NSString *)nickName  merchantAccount:(NSString *)merchant status:(NSString *)status;

//- (void)showWait;
// 隐藏提示内容
- (void)AddChildAccounthidenView;
//



@end

@interface AddChildAccountView : UIView

@property (nonatomic ,strong) NSArray *childAccountArr;
@property (nonatomic ,assign)id<AddChildAccountViewDelegate>delegate;

- (void)saveAddMessage;



@end

