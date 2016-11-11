//
//  BaseViewController.h
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HttpManager.h"
#import "Reachability.h"
#import "Marco.h"
#import "RDVTabBarController.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "GetMerchantInfoDTO.h"
#import "FilesDownManage.h"

#import "Toast+UIView.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RDVTabBarControllerDelegate>

@property(nonatomic,strong)MBProgressHUD *progressHUD;

@property(nonatomic,strong)RDVTabBarController *tabBarController;

/**
 *  显示加载
 *
 *  @param string 加载时显示的文字
 */
- (void)progressHUDShowWithString:(NSString *)string;

/**
 *  隐藏加载动画
 *
 *  @param string 隐藏前显示的文字
 */
- (void)progressHUDHiddenWidthString:(NSString *)string;

/**
 *  加载成功动画
 *
 *  @param string 显示的文字
 */
- (void)progressHUDHiddenTipSuccessWithString:(NSString *)string;

- (void)progressHUDTipWithString:(NSString *)string;

/**
 *  判断网络链接
 *
 *  @return 返回YES是网络畅通。返回NO则是无网络
 */
- (BOOL)isConnecNetWork;

/**
 *  转换数据
 *
 *  @param data 源数据
 *
 *  @return 返回字典格式数据
 */
- (NSDictionary *)conversionWithData:(NSData *)data;

/**
 *  判断请求是否成功
 *
 *  @param code 请求是返回的code
 *
 *  @return 返回YES是请求成功，NO则是失败
 */
- (BOOL)isRequestSuccessWithCode:(NSString*)code;

/**
 *  弹出提示
 *
 *  @param title   标题
 *  @param message 内容
 */
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  判断手机号码的格式是否正确
 *
 *  @param mobileNum 手机号
 *
 *  @return 返回YES是手机格式正确，NO则是错误
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  显示或者隐藏黑色透明NavigationBar
 *
 *  @param show 是否显示
 */
- (void)navigationBarSettingShow:(BOOL)show;

/**
 *  显示或者隐藏Tabbar
 *
 *  @param hide 是否显示
 */
- (void)tabbarHidden:(BOOL)hide;

/**
 *  获取Documents路径
 *
 *  @return 返回Documents路径
 */
- (NSString *)getDocumentsPath;

/**
 *  获取HistoricalAccountList.plist路径
 *
 *  @return 返回HistoricalAccountList.plist路径
 */
- (NSString *)getHistoricalAccountListPath;

/**
 *  创建rightbarbutton or  leftbarbutton
 *
 *  @param title 显示的文字
 *  @param font  字体
 *
 *  @return <#return value description#>
 */
- (UIBarButtonItem *)barButtonWithtTitle:(NSString *)title font:(UIFont*)font;

/**
 *  隐藏navigationbar下面的黑线
 *
 *  @param b yes是隐藏 no是显示
 */
- (void)isHiddenNavigaitonBarButtomLine:(BOOL)b;

/**
 *  提示请求失败
 *
 *  @param errorCode 请求的错误码
 */
- (void)tipRequestFailureWithErrorCode:(NSInteger)errorCode;

/**
 *  UIImage转为NSData
 *
 *  @param image UIImage
 *
 *  @return NSData
 */
- (NSData *)getDataWithImage:(UIImage *)image;

/**
 *  检查数据的合法
 *
 *  @param data  data为任意对象数据
 *  @param class 需要检查的类型
 *
 *  @return <#return value description#>
 */
- (BOOL)checkData:(id)data class:(Class)class;


-(void)setExtraCellLineHidden: (UITableView *)tableView;

- (NSString *)getStringWithArray:(NSMutableArray *)array;

/**
 *  将数据转换为nsstring
 *
 *  @param data nsnumber、nsstring
 *
 *  @return 返回nsstring
 */
- (NSString *)transformationData:(id)data;

/**
 *  自定义返回按钮
 */
- (void)customBackBarButton;


/**
 *  将数字转为字符串
 *
 *  @param number NSInterger
 */
- (NSString *)getStringFromNumber:(NSInteger)number;


- (void)getMerchantInfo;


- (BOOL)filesDownLimit;

- (NSString *)replaceNilWithString:(NSString*)string;

- (void)alertWithAlertTip:(NSString*)msg;

- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format;
- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format timeZone:(NSInteger)second;



- (void)initTabBarController;

//- (void)rightButtonClick:(UIButton *)sender;

//拨打客服电话
- (void)takeServicePhone:(NSString *)phoneNumber;
@end
