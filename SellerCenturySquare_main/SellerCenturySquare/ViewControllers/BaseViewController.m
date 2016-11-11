//
//  BaseViewController.m
//  SellerCenturySquare
//
//  Created by GuChenlong on 15/7/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "MyUserDefault.h"
#import "RDVTabBarItem.h"
#import "GUAAlertView.h"// !提示的view
#import "PurchaserViewController.h"
#import "StatisticalViewController.h"
#import "NewsViewController.h"
//#import "CPSGoodsViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "OrderMainListViewController.h"

#import "GoodsHomeViewController.h"

static NSString * const successfulOperation = @"000";

static NSInteger const errorCodeWithoutNetwork = -1004;

static NSInteger const errorCodeWithConnectFailure = -1011;

@interface BaseViewController ()
{
    GUAAlertView *  alertView;
    
    PrepaiduUpgradeViewController *purchaseVC;
    BOOL  isPurchase;
}

@end

@implementation BaseViewController


- (void)tipRequestFailureWithErrorCode:(NSInteger)errorCode{
    
    if (errorCode == errorCodeWithoutNetwork) {
        
        [self progressHUDHiddenWidthString:@"未能连接到服务器"];
        
    }else if (errorCode == errorCodeWithConnectFailure){
        
        [self progressHUDHiddenWidthString:@"服务器连接失败"];
        
    }else{
        
        [self progressHUDHiddenWidthString:@"请求失败"];
    }
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.progressHUD];
    
    [self.view bringSubviewToFront:self.progressHUD];
    isPurchase = YES;

    
    [self initTabBarController];
    
//    [self customBackBarButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

- (void)initTabBarController{
    
    self.tabBarController = [[RDVTabBarController alloc]init];
    
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CPSMainViewController"]];
        mainNav.navigationBar.barStyle = UIBarStyleBlack;
        mainNav.navigationBar.translucent = NO;
    
    //    UINavigationController *buyerNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CPSBuyerViewController"]];
    
    //采购商
//    PurchaserViewController * purchaseVC = [[PurchaserViewController alloc]init];
//    UINavigationController *buyerNav = [[UINavigationController alloc]initWithRootViewController:purchaseVC];
//    buyerNav.navigationBar.barStyle = UIBarStyleBlack;
//    buyerNav.navigationBar.translucent = NO;

    
    purchaseVC = [[PrepaiduUpgradeViewController alloc]init];
    UINavigationController *buyerNav = [[UINavigationController alloc]initWithRootViewController:purchaseVC];
    buyerNav.navigationBar.barStyle = UIBarStyleBlack;
    buyerNav.navigationBar.translucent = NO;
    purchaseVC.isPurchase = isPurchase;
    purchaseVC.file = [HttpManager memberOfTradeNetworkRequestWebView];
    
    
    //!叮咚
   // NewsViewController *newsVC = [[NewsViewController alloc]init];
    UINavigationController *newsNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"]];
    newsNav.navigationBar.barStyle = UIBarStyleBlack;
    newsNav.navigationBar.translucent = NO;
    
    
    //!采购单
    OrderMainListViewController *orderListVC = [[OrderMainListViewController alloc] init];

//    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"CPSOrderViewController"]];
    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:orderListVC];

    orderNav.navigationBar.barStyle = UIBarStyleBlack;
    orderNav.navigationBar.translucent = NO;
    
    
    //!商品
    UINavigationController *goodsNav = [[UINavigationController alloc]initWithRootViewController:[[GoodsHomeViewController alloc]init]];
    
//    UINavigationController *goodsNav = [[UINavigationController alloc]initWithRootViewController:[[CPSGoodsViewController alloc]init]];

    goodsNav.navigationBar.barStyle = UIBarStyleBlack;
    goodsNav.navigationBar.translucent = NO;
    
    
    //统计
    //    StatisticalViewController *statisticalVC = [[StatisticalViewController alloc]init];
    //    UINavigationController *countNav = [[UINavigationController alloc]initWithRootViewController:statisticalVC];
    
    
    NSArray *viewControllersArray = [[NSArray alloc]initWithObjects:mainNav,buyerNav,newsNav,orderNav,goodsNav, nil];
    
    [self.tabBarController setViewControllers:viewControllersArray];
    
    
    self.tabBarController.delegate = self;
    
    self.tabBarController.tabBar.backgroundView.backgroundColor = [UIColor blackColor];
    NSArray *tabBarItemImages = @[@"tabbar_main", @"tabbar_purchase", @"tabbar_news",@"tabbar_order",@"tabbar_good"];
    NSArray *tabBarSelectedImages = @[@"tabbar_mainSelected",@"tabbar_purchaseSelected",@"tabbar_newsSelected",@"tabbar_orderSelected",@"tabbar_goodSelected"];
    
    
    
    NSArray *tabBarItemTitles = @[@"主页", @"采购商",@"叮咚", @"采购单",@"商品"];
    
    NSInteger index = 0;
    
    for (int i=0; i<tabBarItemImages.count; i++) {
        
        RDVTabBarItem *item = [[self.tabBarController tabBar] items][i];
        
        UIImage *selectedimage = [UIImage imageNamed:tabBarSelectedImages[i]];
        
        
        UIImage *unselectedimage = [UIImage imageNamed:tabBarItemImages[i]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        [item setTitle:[NSString stringWithFormat:@"%@",[tabBarItemTitles objectAtIndex:index]]];
        
        index++;
        
    }
    
    
}


- (void)progressHUDShowWithString:(NSString *)string{
    [self.view bringSubviewToFront:self.progressHUD];

    [self.progressHUD show:YES];
    
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.progressHUD.labelText = string;
}

- (void)progressHUDTipWithString:(NSString *)string{
    
    [self.progressHUD show:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    
    self.progressHUD.labelText = string;
    
    [self.progressHUD hide:YES afterDelay:2];
}

- (void)progressHUDHiddenWidthString:(NSString *)string{
    
    self.progressHUD.mode = MBProgressHUDModeText;
    
    self.progressHUD.labelText = string;
    
    [self.progressHUD hide:YES afterDelay:2];
}

- (BOOL)isConnecNetWork{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            break;
            
        default:
            
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}

- (NSDictionary *)conversionWithData:(NSData *)data{
    
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
}

- (BOOL)isRequestSuccessWithCode:(NSString*)code{
    
    if ([code isEqualToString:successfulOperation]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    
//    [alertView show];
    
    if (alertView) {
        [alertView removeFromSuperview];
        
    }
    
    alertView = [GUAAlertView alertViewWithTitle:title withTitleClor:nil message:message withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        
        
    } dismissAction:^{
        
    }];
    
    [alertView show];
    
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//显示或隐藏黑色透明NavigationBar
- (void)navigationBarSettingShow:(BOOL)show{
    
    

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    UIColor * color = [UIColor whiteColor];
    
     NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBarHidden = !show;

    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    
    /*更改返回按钮图片
    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    */
     
    self.navigationItem.backBarButtonItem=backItem;
}

//Tabbar显示和隐藏
- (void)tabbarHidden:(BOOL)hide{
    
    [[self rdv_tabBarController] setTabBarHidden:hide animated:YES];
    
}


- (NSString *)getDocumentsPath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (NSString *)getHistoricalAccountListPath{
    
    NSString *documents = [self getDocumentsPath];
    

    return [documents stringByAppendingPathComponent:@"3"];
}


- (UIBarButtonItem *)barButtonWithtTitle:(NSString *)title font:(UIFont*)font{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [self getWidthWithString:title font:font];
    
    rightButton.frame = CGRectMake(0, 0, width, 44);
    
    rightButton.titleLabel.font = font;
    
    [rightButton setTitleColor:HEX_COLOR(0x999999FF) forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void)rightButtonClick:(UIButton *)sender{
    
}

- (CGFloat )getWidthWithString:(NSString *)string font:(UIFont*)font{
    
    CGSize sizeName = [string sizeWithFont:font
                          constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    return sizeName.width;
}

- (void)isHiddenNavigaitonBarButtomLine:(BOOL)b{
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=b;
                    }
                }
            }
        }
    }
}

- (void)progressHUDHiddenTipSuccessWithString:(NSString *)string{
    
    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    self.progressHUD.labelText = string;
    
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    [self.progressHUD hide:YES afterDelay:2];
}

- (NSData *)getDataWithImage:(UIImage *)image{
    
    NSData *data;
    
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    
    return data;
}

- (BOOL)checkData:(id)data class:(Class)class{
    
    if (data && [data isKindOfClass:class]){
        return YES;
    }else{
        return NO;
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

- (NSString *)getStringWithArray:(NSMutableArray *)array{
    
    NSString *string;
    
    for (int i = 0; i<array.count; i++) {
        
        if (i == 0) {
            string = [array objectAtIndex:i];
        }else{
            string = [NSString stringWithFormat:@"%@,%@",string,[array objectAtIndex:i]];
        }
    }
    
    return string;
    
}

- (NSString *)transformationData:(id)data{
    
    if ([data isKindOfClass:[NSString class]]) {
        
        return data;
        
    }else if ([data isKindOfClass:[NSNumber class]]){
        
        NSNumber *number = (NSNumber *)data;
        
        return number.stringValue;
    }else{
        return @"";
    }
    
}

- (void)customBackBarButton{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
  
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)getStringFromNumber:(NSInteger)number{
    
    return [NSString stringWithFormat:@"%ld",(long)number];
}

//数据初始化
- (void)getMerchantInfo{
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                [MyUserDefault  setJudgeUserAccount:dic[@"data"][@"isMaster"]];
                
                
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    
    } ];
    
}

- (BOOL)filesDownLimit{
    
    return YES;
    
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    
    NSMutableArray *downingArray = filedownmanage.downinglist;
    
    if (downingArray.count>=5) {
        
        return NO;
        
    }else{
        
        return YES;
    }
}

- (NSString *)replaceNilWithString:(NSString*)string{
    
    if (string==nil) {
        string = @" ";
    }else if ([string isEqualToString:@""]){
        string =@" ";
    }
    return string;
    
}

- (void)alertWithAlertTip:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


//根据date返回string
- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format timeZone:(NSInteger)second{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:second]];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
    
}

- (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
}

- (void)takeServicePhone:(NSString *)phoneNumber{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}


@end
