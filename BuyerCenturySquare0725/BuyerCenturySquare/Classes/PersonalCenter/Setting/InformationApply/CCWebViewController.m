//
//  CCWebViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/28.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CCWebViewController.h"
#import "WebViewJavascriptBridge.h"

#import "HttpManager.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "TokenLoseEfficacy.h"
#import "MerchantDeatilViewController.h"
#import "GUAAlertView.h"
#import "MerchantListDetailsDTO.h"
#import "IMGoodsInfoDTO.h"
#import "ConversationWindowViewController.h"
#import "DoubleSku.h"
#import "StepListDTO.h"
#import "TokenLoseEfficacy.h"
#import "GoodsInfoDTO.h"
#import "GoodDetailViewController.h"
#import "GoodsNotLevelTipDTO.h"
#import "CSPAuthorityPopView.h"
#import "MerchantDeatilViewController.h"
#import "MembershipUpgradeViewController.h"
#import "MembershipGradeRulesViewController.h"
#import "BalanceChargeViewController.h"

#import "PrepaiduUpgradeViewController.h"
#import "CustomBarButtonItem.h"
#import "AppleAccountsView.h"
#import "CSPPayAvailabelViewController.h"
#import "UIColor+UIColor.h"
#import "LoadFailedView.h"

#import "SettingModel.h"
#define WebViewNav_TintColor ([UIColor colorWithHexValue:0xfd4f57 alpha:1])
@interface CCWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,CSPAuthorityPopViewDelegate,LoadFailedDelegate>
{
    BOOL isOK;
    UIWebView *webView;
    UIProgressView *progressView;
    
}
@property (nonatomic ,strong) LoadFailedView *loadFailView;

@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *homeUrl;


@property WebViewJavascriptBridge* bridge;

@end

@implementation CCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isOK = YES;
    [self addCustombackButtonItem];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleVC;
    
    
    
    //根据接口进行苹果账号判断
    SettingModel *settingModel = [[SettingModel alloc]init];
    
    [settingModel setShowMoneyPage:^(NSString *str) {
        
        //        [MyUserDefault saveH5RegistFlagAcount:str];
        
        if ([str isEqualToString:@"1"]) {
            
            AppleAccountsView *appleView = [[[NSBundle mainBundle] loadNibNamed:@"AppleAccountsView" owner:self options:nil]lastObject];
            
            appleView.frame = CGRectMake(0,0 , 200, 100);
            
            appleView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
            
            [self addCustombackButtonItem];
            
            [self.view addSubview:appleView];
            
        }else
        {
            [self configUI];
            
        }
        
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    
    self.isOK = NO;
    self.isPay = NO;
    self.isRecond = NO;
    self.isRule = NO;
    self.isProtocal = NO;
}

- (void)configUI {
    
    _homeUrl = [NSURL URLWithString:self.file];
    
    // 进度条
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.scrollView.scrollEnabled = NO;
    
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view insertSubview:webView belowSubview:progressView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_homeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
    
    [webView loadRequest:request];
    self.webView = webView;
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    //启动
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    //1.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0"} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    //2.发送消息
    [_bridge registerHandler:@"getDefaultParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data  ====%@",data);
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
        newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
    }];
    
    //3.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    
    //4.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    //5.显示tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    
    
    //6.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //7.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    //8.商家列表详情页面
    [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data) {
            
            MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
            detailVC.merchantNo = data[@"merchantNo"];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
    }];
    
    
    //9.讯单
    [_bridge registerHandler:@"buyerToSellerChat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        if ([self.delegate respondsToSelector:@selector(enterTheChatPageOfTheServiceDic:)]) {
            
            [self.delegate enterTheChatPageOfTheServiceDic:data];
            
        }
    }];
    
    
#pragma mark token失效(reLogin)
    //11.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
    //12.弹出提示窗口
    [_bridge registerHandler:@"dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        if ([data[@"type"] isEqualToString:@"1"]) {
            
            [self.view makeMessage:data[@"msg"] duration:2.0f position:@"center"];
            
        }
        
        if ([data[@"type"] isEqualToString:@"2"]) {
            [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:nil type:data[@"type"]];
        }
        
        
        if ([data[@"type"] isEqualToString:@"3"]) {
            
            
            
            //1、创建
            [[GUAAlertView alertViewWithTitle:@"温馨提示" withTitleClor:nil message:data[@"msg"] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"true"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                responseCallback(json);
                
                
            } dismissAction:^{
                
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"false"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                responseCallback(json);
                //进入修改登录密码页面
                NSLog(@"左边按钮（第二个按钮）的事件");
                
            }]show];
        }
        
    }];
    
    //13.进行隐藏
    [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"merchantNo"]) {
            
            MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
            detailVC.merchantNo = data[@"merchantNo"];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
        
    }];
    //14.讯单
    [_bridge registerHandler:@"buyerToSellerChat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        if ([self.delegate respondsToSelector:@selector(enterTheChatPageOfTheServiceDic:)]) {
            
            [self.delegate enterTheChatPageOfTheServiceDic:data];
            
        }
    }];
    
    
    //15.讯单
    [_bridge registerHandler:@"buyerToSellerConsult" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = (NSDictionary *)data;
        NSLog(@"%@",dic[@"price"]);
        
        //        GoodsInfoDetailsDTO *goodsInfo = dic[@"list"];
        //        BOOL hasSelectedModel = [dic[@"model"] isEqualToString:@"0"]?YES:NO;
        
        
        //组装信息
        IMGoodsInfoDTO * goodsInfoDTO = [[IMGoodsInfoDTO alloc] init];
        
        goodsInfoDTO.merchantName = dic[@"merchantName"];
        goodsInfoDTO.sessionType = 1;
        goodsInfoDTO.goodColor = dic[@"color"];
        
        goodsInfoDTO.goodPic = dic[@"imgUrl"];
        
        
        goodsInfoDTO.goodsWillNo = dic[@"CommodityNo"];
        
        //        goodsInfoDTO.isBuyModel = 1;
        goodsInfoDTO.merchantNo = dic[@"merchantNo"];
        goodsInfoDTO.goodsNo = dic[@"goodsNo"];
        goodsInfoDTO.cartType = @"0";
        goodsInfoDTO.price = [NSNumber numberWithFloat:[dic[@"price"] floatValue]];
        goodsInfoDTO.totalQuantity = [NSNumber numberWithInteger:0];
        
        NSMutableArray *skuListArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSArray *arr = dic[@"skuListBean"];
        
        for (NSDictionary *tmpDic in arr) {
            
            DoubleSku *doubleSku = [[DoubleSku alloc]init];
            
            [doubleSku setDictFrom:tmpDic];
            
            [skuListArr addObject:doubleSku];
            
        }
        
        goodsInfoDTO.skuList = skuListArr;
        
        NSDictionary *sampleInfo = dic[@"skuListBean"];
        goodsInfoDTO.samplePrice = dic[@"price"] ;
        
        if ([sampleInfo isKindOfClass:[NSDictionary class]]) {
            goodsInfoDTO.sampleSkuNo = sampleInfo[@"skuNo"];
        }
        
        goodsInfoDTO.batchNumLimit = dic[@"limit"];
        
        NSMutableArray *stepList = dic[@"stepList"];
        NSMutableArray *stepListArr = [[NSMutableArray alloc]init];
        for (NSDictionary *tmpDic in stepList) {
            
            StepListDTO *stepListDTO = [[StepListDTO alloc]init];
            [stepListDTO setDictFrom:tmpDic];
            [stepListArr addObject:stepListDTO];
        }
        goodsInfoDTO.stepPriceList = stepListArr;
        
        [self getIMName:goodsInfoDTO.merchantName withGood:goodsInfoDTO];
        
    }];
    
    
    //16.商品收藏点击详情页面
    [_bridge registerHandler:@"goodsDetails" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSLog(@"data == %@",data[@"authFlag"]);
        
        if ([data[@"authFlag"] isEqualToString:@"1"]) {
            GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
            
            goodsInfoDTO.goodsNo = data[@"goodsNo"];
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
            [self.navigationController pushViewController:goodsInfo animated:YES];
        }else
        {
            [self showNotLevelReadTipForGoodsNo:data[@"goodsNo"]];
        }
        
    }];
    
    //17.充值
    [_bridge registerHandler:@"prepaidRecharge" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BalanceChargeViewController *balance = [[BalanceChargeViewController alloc] init];
        
        [self.navigationController pushViewController:balance animated:YES];
        
    }];
    
    //18.顶栏导航栏与js的交互
    [_bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
        prepaiduUpgradeVC.titleRecord = data[@"targetTitle"];
        prepaiduUpgradeVC.file = [NSString stringWithFormat:@"%@%@",[HttpManager nextPageInterface],data[@"targetUrl"]];
        [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
        
    }];
    
    
    //19.设置原生导航栏title
    [_bridge registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (self.isOK == YES) {
            self.title = data[@"targetTitle"];
        }
        
        if (self.isPay == YES) {
            self.title = data[@"targetTitle"];
        }
        
        if (self.isRecond == YES) {
            self.title = data[@"targetTitle"];
        }
        if (self.isRule == YES) {
            self.title = data[@"targetTitle"];
        }
        if (self.isTitle == YES) {
            self.title = data[@"targetTitle"];
            
            self.navigationItem.rightBarButtonItem = [[CustomBarButtonItem alloc]initWithTitle:data[@"rightTitle"] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickMembershipPrivilege)];
            
            self.file = [NSString stringWithFormat:@"%@%@",[HttpManager accessSecondaryPageURL],data[@"rightTitleUrl"]];
            
        }
        
        if (self.isProtocal == YES) {
            self.title = data[@"targetTitle"];
            
        }
        
        if (self.isPrepay == YES) {
            self.title = data[@"targetTitle"];
            self.navigationItem.rightBarButtonItem = [[CustomBarButtonItem alloc]initWithTitle:data[@"rightTitle"] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickMembershipPrivilege)];
            
            self.file = [NSString stringWithFormat:@"%@%@",[HttpManager accessSecondaryPageURL],data[@"rightTitleUrl"]];
        }
        
    }];
    
    //20.进行付款
    [_bridge registerHandler:@"recharge" handler:^(id data, WVJBResponseCallback responseCallback) {
        /*
         if ([self.delegate respondsToSelector:@selector(jumpToPayInterfaceDic:)]) {
         [self.delegate jumpToPayInterfaceDic:data];
         }
         */
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
        payAvailabelViewC.dic = data;
        //status true表示成功，false表示失败
        
        [self.navigationController pushViewController:payAvailabelViewC animated:YES];
        
    }];
    
}
//会员特权（导航栏右按钮进行点击事件）
-(void)didClickMembershipPrivilege
{
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    
    prepaiduUpgradeVC.file = self.file;
    prepaiduUpgradeVC.isOK = isOK;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    
}

/**
 *  立即升级
 */
- (void)prepareToUpgradeUserLevel{
    
    
    MembershipUpgradeViewController *membershipUpgradeVC = [[MembershipUpgradeViewController alloc]init];
    
    [self.navigationController pushViewController:membershipUpgradeVC animated:YES];
    
}

//!查看商品详情权限不足的提示view 的代理方法
- (void)showLevelRules{
    
    MembershipGradeRulesViewController *membershipGradeRulesVC = [[MembershipGradeRulesViewController alloc]init];
    
    [self.navigationController pushViewController:membershipGradeRulesVC animated:YES];
    
}



#pragma mark 显示等级详情
- (void)showNotLevelReadTipForGoodsNo:(NSString*)goodsNo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            //参数需要保存
            GoodsNotLevelTipDTO *goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                NSLog(@"the currentLevel is %@\n",goodsNotLevelTipDTO.currentLevel);
                
                CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                popView.frame = self.view.bounds;
                popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                
                popView.delegate = self;
                [self.view addSubview:popView];
                
            } else {
                
                [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
            }
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询权限失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
    }];
}

- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}





-(void)setPopUpBoxStyleTitle:(NSString *)title  message:(NSString *)message buttonTitle:(NSString *)buttonTitle canceButtonTitle:(NSString *)canceButtonTitle  type:(NSString *)type
{
    
    //1、创建
    [[GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:buttonTitle withOkButtonColor:nil cancelButtonTitle:canceButtonTitle withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        //对type返回过来的值进行处理
        if ([type isEqualToString:@"2"])
        {
            
            
            
        }else
        {
            
            
            
        }
        NSLog(@"右边按钮（第一个按钮）的事件");
        
    } dismissAction:^{
        
        //进入修改登录密码页面
        NSLog(@"左边按钮（第二个按钮）的事件");
        
    }]show];
}




- (void )getIMName:(NSString *)merchantName withGood:(IMGoodsInfoDTO *)goodsInfoDTO{
    [HttpManager sendHttpRequestForGetMerchantRelAccount:goodsInfoDTO.merchantNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString * jid = [NSString stringWithFormat:@"%@",dic[@"data"]];
            
            
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];
            
            NSArray *arrDto = [[NSArray alloc] initWithObjects:goodsInfoDTO, nil];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:merchantName jid:jid withArray:arrDto];
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;
            
            [self.navigationController pushViewController:conversationVC animated:YES];
        }else{
            
        }
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
}
//!升级
-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    payAvailabelViewC.dic = dic;
    
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
    
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        
        CGFloat newP = (1.0 - oldP) * 2 / (loadCount + 1) + oldP;
        
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.loadCount --;
    NSLog(@"webViewDidFinishLoad");
    [self.loadFailView removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if([error code] == NSURLErrorCancelled)  {//!webview在之前的请求还没有加载完成，下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。此时的code ==  NSURLErrorCancelled
        
        return;
    }

    self.loadCount --;
    NSLog(@"didFailLoadWithError:%@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.loadFailView = [[[NSBundle mainBundle] loadNibNamed:@"LoadFailedView" owner:self options:nil]lastObject];
    
    self.loadFailView.delegate = self;
    
    self.loadFailView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //    self.view.center = self.loadFailView.center;
    //        self.loadFailView.center = CGPointMake(self.view.center.x, self.view.center.y - 139);
    
    [self.view addSubview:self.loadFailView];
    
}

#pragma mark - LoadFailedDelegate

- (void)loadFailedAgainRequest
{
    [self.loadFailView removeFromSuperview];
    
    [webView removeFromSuperview];
    [progressView removeFromSuperview];
    
    [self configUI];
    
}
@end
