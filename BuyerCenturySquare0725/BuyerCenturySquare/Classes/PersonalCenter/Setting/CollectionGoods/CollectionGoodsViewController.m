//
//  CollectionGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/3.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CollectionGoodsViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
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
#import "PrepaiduUpgradeViewController.h"//!等级规则
#import "CCWebViewController.h"//!立即升级

@interface CollectionGoodsViewController ()<UIWebViewDelegate,CSPAuthorityPopViewDelegate>
{

}
@property WebViewJavascriptBridge* bridge;
@end

@implementation CollectionGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.view addSubview:statusBarView];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    [HttpManager collectionGoodNetworkRequestWebView:self.webView];
    [self.view addSubview:self.webView];
    
#pragma mark -----与h5交互写入plist文件当中-------
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
    
    
    //1.销毁当前页面
    [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([self.delegate respondsToSelector:@selector(backEliminateCollectionGoodsWebView)]) {
            [self.delegate performSelector:@selector(backEliminateCollectionGoodsWebView)];
        }
        
    }];
    
    //2.获取设备状态栏高度
    [_bridge registerHandler:@"getStatusBarHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"statusBarHeight":@"0",@"code":@"000"} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    //3.发送消息
    [_bridge registerHandler:@"getDefaultParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data  ====%@",data);
        
        NSString *timeStamp = [HttpManager getTimesTamp];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newDic options:NSJSONWritingPrettyPrinted error:nil];
        
         newDic[@"timestamp"] = timeStamp;
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    //4.加密
    [_bridge registerHandler:@"encodingParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
        
        NSString *digest = [HttpManager getSignWithParameter:data];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"digest":digest} options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        responseCallback(json);
        
    }];
    
    //5.弹出提示窗口
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
    
    //6.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
    }];
    
    //7.显示tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }];
    
    //8.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //9.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    

    //10.进行隐藏
    [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
    
        if (data[@"merchantNo"]) {
            
            MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
            detailVC.merchantNo = data[@"merchantNo"];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
        
    }];

        
        //10.讯单
        [_bridge registerHandler:@"buyerToSellerChat" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            
            if ([self.delegate respondsToSelector:@selector(enterTheChatPageOfTheServiceDic:)]) {
                
                [self.delegate enterTheChatPageOfTheServiceDic:data];
                
            }
        }];
        

        
        
#pragma mark token失效(reLogin)

    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];

    //8.讯单
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
        goodsInfoDTO.shopLevel = [NSNumber numberWithInt:[dic[@"shopLevel"]intValue]];
               
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
    
    
    //9.商品收藏点击详情页面
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
}

/**
 *  立即升级
 */
- (void)prepareToUpgradeUserLevel{
    
    CCWebViewController * cc = [[CCWebViewController alloc]init];
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    //bool 值进行判断
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];
    
}

//!查看商品详情权限不足的提示view 的代理方法
- (void)showLevelRules{
    
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    //bool值进行名字判断
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    
    
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
            
            NSNumber *isExit = dic[@"data"][@"isExit"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSArray *arrDto = [[NSArray alloc] initWithObjects:goodsInfoDTO, nil];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:merchantName jid:jid withArray:arrDto];
            conversationVC.timeStart = time;
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







@end
