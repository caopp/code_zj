//
//  PurchaserViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PurchaserViewController.h"
#import "HttpManager.h"
#import "WebViewJavascriptBridge.h"
#import "AppInfoDTO.h"
#import "SaveJSWithNativeUserIofo.h"
#import "GUAAlertView.h"
#import "InviteTableViewController.h"
#import "ConversationWindowViewController.h"
#import "TokenLoseEfficacy.h"
#import "XHJAddressBook.h"
#import "PersonModel.h"
#import "AddressMessageBook.h"
@interface PurchaserViewController ()<UIWebViewDelegate>
{
    BOOL _showTabBar;//显示底部tabbar
}
@property WebViewJavascriptBridge* bridge;
@property (nonatomic,strong) XHJAddressBook *addBook;
@property (nonatomic ,strong) NSMutableArray *addressListArr;


@end

@implementation PurchaserViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    
    if (_showTabBar) {

        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        self.webView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    }else {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
    
    [self.view addSubview:statusBarView];



}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    _showTabBar = YES;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    self.webView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    
    self.addressListArr = [NSMutableArray array];
    _showTabBar = YES;
    
    SaveJSWithNativeUserIofo * info =[[SaveJSWithNativeUserIofo alloc]init];
    
    
#pragma mark -----与h5交互写入plist文件当中-------
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"H5UserIofoPlist.plist"];
    NSMutableDictionary *newDic;
    newDic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    
    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.scrollView.scrollEnabled = NO;
    //根据网络路径进行网路请求
    //商家特权
    [HttpManager memberOfTradeNetworkRequestWebView:self.webView];
    [self.view addSubview:self.webView];
    
    
    
    
#pragma mark -----与h5交互写入plist文件当中-------
    //启动
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    //1.销毁当前页面
    [_bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.navigationController popViewControllerAnimated:YES];
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
            [self.view makeMessage:data[@"msg"] duration:1.0f position:@"center"];
        }
        
        if ([data[@"type"] isEqualToString:@"2"]) {
            [self setPopUpBoxStyleTitle:@"温馨提示" message:data[@"msg"] buttonTitle:@"确定" canceButtonTitle:nil type:data[@"type"]];
            
        }
        
        if ([data[@"type"] isEqualToString:@"3"]) {
            
            
            //1、创建
            [[GUAAlertView alertViewWithTitle:@"温馨提示" withTitleClor:nil message:data[@"msg"] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
                NSLog(@"右边按钮（第一个按钮）的事件");

                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"true"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                responseCallback(json);
                
                
            } dismissAction:^{
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"result":@"false"} options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                //进入修改登录密码页面
                NSLog(@"左边按钮（第二个按钮）的事件");
                responseCallback(json);
                
            }]show];
        }
    }];
    
    
    
    
    //7.充值预付款
    [_bridge registerHandler:@"recharge" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data ==== %@",data);
    }];


     //8.跳到商家列表
    [_bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {

        
    }];

    //9.拨打电话
    [_bridge registerHandler:@"phoneCalls" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
    
        NSString *num = [NSString stringWithFormat:@"tel://%@",data[@"telephoneNum"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
        
    }];
    
    

    
   //10.邀请采购商
    [_bridge registerHandler:@"inviteBuyer" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InviteTableViewController *inviteTableVC = [storyboard instantiateViewControllerWithIdentifier:@"InviteTableViewController"];
        [self.navigationController pushViewController:inviteTableVC animated:YES];
        
        _showTabBar = YES;
        
     }];
    
    
    
    //11.询单对话
    [_bridge registerHandler:@"chat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data === %@",data);
        
        
        NSString *name =data[@"nickName"];
        
        NSString *JID = data[@"chatAccount"];
         _showTabBar = [data[@"showTabBar"] boolValue];
        
        //NSString *memberNo = IMInfo[@"memberNo"];
        
        ConversationWindowViewController *IMVC = [[ConversationWindowViewController alloc] initWithNameWithYOffsent:name withJID:JID withMemberNO:data[@"memberNo"]];

        
        [self.navigationController pushViewController:IMVC animated:YES];
        
        
    }];

    AddressMessageBook *address = [[AddressMessageBook alloc] init];

    //.匹配通讯录
    [_bridge registerHandler:@"getNameFromContacts" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        address.blockPer = ^()
        {
//            if ([name isEqualToString:@"no"]) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"namesNumbers":@"",@"result":@""} options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

                responseCallback(json);

//            }
            return ;
        };
        address.blockPhoneName = ^(NSArray *messArr)
        {
            
            //将匹配到的通讯录存到数组中
            NSMutableArray *mateAddress = [NSMutableArray array];
            
            //获取JS穿过来的电话号码
            NSDictionary *addressDic = data;
            
            NSString *addressStr  = addressDic[@"numbers"];
            NSArray *arrList = [addressStr componentsSeparatedByString:@","];
            //循环来判断
            for (NSDictionary  *personAddress in messArr) {
                NSLog(@"name= %@ tel = %@",personAddress[@"name"],personAddress[@"tel"]);

                for (NSString *phone in arrList) {
                    NSString*tel = [NSString stringWithFormat:@"%@",personAddress[@"tel"]];
                    NSString *phoneTel = [NSString stringWithFormat:@"%@",phone];
                    if ([phoneTel isEqualToString:tel]) {
                        NSLog(@"name= %@ tel = %@",personAddress[@"name"],personAddress[@"tel"]);
                        
                        NSDictionary *dict = @{@"name":personAddress[@"name"],@"tel":personAddress[@"tel"]};
                        //添加到数组中
                        [mateAddress addObject:dict];
                        
                        
                    }
                }
            }
            
            //返回JS匹配到的数据
            NSDictionary *mateAddresssDict = @{@"namesNumbers":mateAddress,@"result":@"true"};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mateAddresssDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            responseCallback(json);

        };
        
        //通讯录
        [address getPhoneContracts];

        
//        //将匹配到的通讯录存到数组中
//        NSMutableArray *mateAddress = [NSMutableArray array];
//        
//        //获取JS穿过来的电话号码
//        NSDictionary *addressDic = data;
//        
//        NSString *addressStr  = addressDic[@"numbers"];
//        NSArray *arrList = [addressStr componentsSeparatedByString:@","];
//        //循环来判断
//        for (PersonModel *personAddress in self.addressListArr) {
//            for (NSString *phone in arrList) {
//                NSString*tel = [NSString stringWithFormat:@"%@",personAddress.tel];
//                NSString *phoneTel = [NSString stringWithFormat:@"%@",phone];
//                if ([phoneTel isEqualToString:tel]) {
//                    NSLog(@"name= %@ tel = %@",personAddress.name1,personAddress.tel);
//                    
//                    NSDictionary *dict = @{@"name":personAddress.name1,@"tel":personAddress.tel};
//                    //添加到数组中
//                    [mateAddress addObject:dict];
//                    
//                    
//                }
//            }
//        }
//        
//        //返回JS匹配到的数据
//        NSDictionary *mateAddresssDict = @{@"namesNumbers":mateAddress,@"result":@"true"};
//        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mateAddresssDict options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        responseCallback(json);
        

    }];
    
    
    
#pragma mark token失效(reLogin)
    //10.回到登陆页面
    [_bridge registerHandler:@"reLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        TokenLoseEfficacy *tokenVC = [[TokenLoseEfficacy alloc] init];
        [tokenVC showLoginVC];
        
    }];
    
    //12.显示tap
    [_bridge registerHandler:@"showTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([self rdv_tabBarController].tabBarHidden) {
        
            [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
        }
    
        self.webView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        
    }];

    //13.隐藏tap
    [_bridge registerHandler:@"hideTap" handler:^(id data, WVJBResponseCallback responseCallback) {
        
      [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
      self.webView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    }];
    
    
    //14.进行加载
    [_bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }];
    
    //15.加载进行隐藏
    [_bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

    
    
    
}


-(void)setPopUpBoxStyleTitle:(NSString *)title  message:(NSString *)message buttonTitle:(NSString *)buttonTitle canceButtonTitle:(NSString *)canceButtonTitle  type:(NSString *)type
{
    
    //1、创建
    [[GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:buttonTitle withOkButtonColor:nil cancelButtonTitle:canceButtonTitle withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        //对type返回过来的值进行处理
        if ([type isEqualToString:@"2"])
        {
            
            
        }
        
        NSLog(@"右边按钮（第一个按钮）的事件");
        
    } dismissAction:^{
        
        //进入修改登录密码页面
        NSLog(@"左边按钮（第二个按钮）的事件");
        
        
    }]show];
}








@end
