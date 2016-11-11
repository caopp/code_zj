//
//  BussinessAreaController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/16.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BaseJSViewController.h"

@interface BussinessAreaController : BaseJSViewController
//请求需要的URL
@property (nonatomic ,copy) NSString *requestUrl;
/**
 *  设置title
 */
@property (nonatomic ,copy) NSString *selfTitle;
/**
 *  右侧item的名字
 */
@property (nonatomic ,copy) NSString *rightItemTitle;

/**
 *  点击右侧名字跳转的URL
 */
@property (nonatomic ,copy) NSString *rightItemUrl;

//标记为YES
@property (nonatomic ,copy) NSString *makrNotification;

//标记点击叮咚官方的时候根据这个值判断是主列表 还是官方列表
@property (nonatomic ,copy) NSString *makrRightNav;









@end
