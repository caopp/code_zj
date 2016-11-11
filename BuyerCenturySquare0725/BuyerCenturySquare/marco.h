//
//  marco.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
#define CELL_HEIGHT 100 //普通高度
#define CELL_WIDTH 380.0f
#define CELL_CURRHEIGHT 240 //置顶高度
#define TITLE_HEIGHT 40
#define IMAGEVIEW_ORIGIN_Y 0
#define IMAGEVIEW_MOVE_DISTANCE 160

#define NAVIGATOR_LABEL_HEIGHT 25
#define NAVIGATOR_LABELCONTAINER_HEIGHT 125
#define SC_IMAGEVIEW_HEIGHT 360

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define DRAG_INTERVAL 170.0f
#define HEADER_HEIGHT 0.0f
#define RECT_RANGE 1000.0f//  Copyright (c) 2015 pactera. All rights reserved.
//


extern const NSInteger pageSize;


#define CODE @"code"

#define ERRORMESSAGE @"errorMessage"

#define DOWNLOAD_DEFAULTIMAGE @"middle_placeHolder.png"

#define addCartNotification @"addCartNotification"

#define clickCartNotification @"clickCartNotification"

#define addNoticeNotification @"addNoticeNotification"

#define clearNoticeNotification @"clearNoticeNotification"

#define addNewsNotification @"addNewsNotification"
#define clearNewsNotification @"clearNewsNotification"


#define logoutNotice @"logoutNotice"
#define SHOWNEWS @"showNews"
#define personalCenterRefresh @"personalCenterRefresh"

#define FRAMR_Y_FOR_KEYBOARD_SHOW   (-70)
#define FRAMR_Y_FOR_KEYD_SHOW   (-40)

#define CONVERT 1024.00


#define ENABLE_DEBUG

#ifdef ENABLE_DEBUG
#define DebugLog(format, args...) \
NSLog(@"%s, line %d: " format "\n", \
__func__, __LINE__, ## args);
#else
#define DebugLog(format, args...) do {} while(0)
#endif


#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24)) / 255.0 green:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 blue:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 alpha:((float)(rgbValue & 0xFF)) / 255.0]

//不考虑转屏的影响，只取竖屏（UIDeviceOrientationPortrait）的宽高
#define SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define STATUSBAR_HEIGHT MIN([UIApplication sharedApplication].statusBarFrame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)

#define K_ERROR_TOAST_SERVERDATA [self.view makeToast:@"数据异常"];


#import "RDVTabBarController.h"
#import "HttpManager.h"
#import "MBProgressHUD.h"
#import "CSPUtils.h"
#import "SDRefresh.h"


typedef NS_ENUM(NSUInteger, CSPService){
    
    CSPOnlineNewsCheck = 1,
    CSPOnlineGoodsCollection= 2,
    CSPOnlineGoodsShare = 3,
    CSPOnlineGoodsPictureLook = 4,
    CSPOnlineGoodsPictureFree = 5,
    CSPOnlineGoodsPicturePay = 6,
    CSPOfflineAdviseSupplier = 7,
    CSPOfflineGuidance = 8,
    CSPOfflineBuyerAdvise = 9,
    
};

typedef NS_ENUM(NSUInteger, CSPChangePassword){
    
    CSPChangeLoginPassword = 1,
    CSPResetPayPassword = 2,
    CSPForgetPayPassword = 3,
    
};

typedef NS_ENUM(NSUInteger, CSPManageAddress){
    CSPAddNewAddress = 1,
    CSPModifyAddress = 2,
};

typedef NS_ENUM(NSUInteger, CSPImageListType) {
    CSPImageListWindowType,
    CSPImageListObjectiveType,
    CSPImageListReferenceType,
};

typedef NS_ENUM(NSUInteger, CSPPayType){
    
    CSPPayNone  = 1,
    CSPAliPay = 2,
    CSPWeChatPay = 3,
    
};

typedef NS_ENUM(NSUInteger, CSPAuthorityType){
    
    CSPAuthorityCollection  = 1,
    CSPAuthorityDownload = 2,
    CSPAuthorityShare = 3,
    
};



