 //
//  BusinessCircleController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/12/5.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BusinessCircleController.h"
#import "UUInputFunctionView.h"
#import "MWPhotoBrowser.h"
#import "H5_DetailViewController.h"
#import "LoadFailedView.h"
#import "Masonry.h"

#import "MerchantDeatilViewController.h"//!商家店铺列表

#import "MerchantListDetailsDTO.h"
@interface BusinessCircleController ()<UUInputFunctionViewDelegate,UIGestureRecognizerDelegate ,MWPhotoBrowserDelegate ,NJKWebViewProgressDelegate,UIWebViewDelegate>
{
    BOOL isUp;
//    BOOL ishideBar;
    
    UUInputFunctionView *IFView;
    
    NSNumber *recordId;
    NSString *recrodName;
    MWPhotoBrowser *browser;
    
    
}
@property (nonatomic ,strong)NSString *requestURL;
@property (nonatomic ,strong)NSMutableArray *photos;



@property (nonatomic,strong) NSString *bussinessID;
//0 从首页; 1从详情页
@property (nonatomic,strong) NSString *bussinessFrom;
@property (nonatomic ,strong) MerchantListDetailsDTO *merchantDetail;

@property (nonatomic ,strong) NSString *topicType;
@end

@implementation BusinessCircleController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"BusinessCircleController --- viewWillAppear");
    
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    if ([self.title  isEqualToString:@"商圈"]) {
//        [[self rdv_tabBarController] setTabBarHidden:NO];
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
        
        self.navigationController.navigationBar.translucent = NO;
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        
    }else
    {
        [[self rdv_tabBarController] setTabBarHidden:YES];
        [self addCustombackButtonItem];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            
        }];
        
        
    }
}
//在webView 上必须添加
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}


/**
 *  点击空白出收回键盘
 */
-(void)handleSingleTap:(UISwipeGestureRecognizer *)sender
{
    if (!IFView.hidden) {
        [IFView showKeyBoardhiddenAdd:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"BusinessCircleController - viewWillDisappear");
    
}

- (void)viewDidLoad {


    [super viewDidLoad];
    
    self.webView.userInteractionEnabled = YES;

    
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    swipeGesture.delegate =self;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:swipeGesture];
    
    if (self.selfTitle != nil &&self.requestUrl!=nil) {
        self.title = self.selfTitle;
        [HttpManager businessCircleRequestWebView:self.webView requestUrl:self.requestUrl];
        //叮咚官方
        if ([self.requestUrl isEqualToString:@"zone/ddopIndex.html"]) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
        }
        NSString *titleStr = self.requestUrl;
        NSArray *htmlArr = [titleStr componentsSeparatedByString:@"?"];
//        if (htmlArr.count>1) {
            if ([htmlArr[0] isEqualToString:@"zone/sellerIndex.html"]) {
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
  
//            }
        }

    }else
    {
    [HttpManager businessCircleRequestWebView:self.webView];
        self.title = @"商圈";
    }


    [self.view setBackgroundColor:[UIColor whiteColor]];
    

#pragma mark -----设置通知中心---
    
    
    
    //吊起的键盘
    if (!IFView) {
        IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:YES];

    }
    IFView.userInteractionEnabled = YES;
    
    IFView.delegate = self;
    
    [self.webView addSubview:IFView];
    IFView.hidden = YES;
    
    
    //11.发布资讯或测评
    [self.bridge registerHandler:@"addTopicInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data[@"topicType"] isEqualToString:@"1"]) {
            [self goUpLoadPhotosViewControllerReleaseType:@"1"];
            
        }else if ([data[@"topicType"] isEqualToString:@"0"])
        {
            [self goUpLoadPhotosViewControllerReleaseType:@"0"];
            
        }
        
    }];
    
    //    showBigPic12.预览图片
    
    [self.bridge registerHandler:@"showBigPic" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        
        NSDictionary *dict = data;
        NSString *urlStr = data[@"imgUrls"] ;
        NSString *str = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *urlArr = [str componentsSeparatedByString:@","];
        NSString *position = data[@"position"];
        
        NSString *from = data[@"from"];
        self. bussinessFrom = from;
        self.topicType = data[@"topicType"];
        NSString *uiD = data[@"id"];
        
        if ([from isEqualToString:@"0"]) {
//            ishideBar = NO;
            
        }else {
//            ishideBar = YES;
            
        }
        
        self.bussinessID = uiD;
        
        
        /**
         *  MWPhotoBrowser 第三方调用方法
         */
        
        // Browser
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        MWPhoto *photo, *thumb;
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        
        if (urlArr.count>0) {
            
            for (NSString *url in urlArr) {
                
                photo  = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
                
                [photos addObject:photo];
                
            }
            [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

            self.photos    = photos;
            // Create browser
            browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
//            browser.zoomPhotosToFill = YES;
            browser.from = from;
            browser.enableGrid = enableGrid;
            browser.startOnGrid = startOnGrid;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = autoPlayOnAppear;
            [browser setCurrentPhotoIndex:position.integerValue];
            browser.isback = from;
            [self.navigationController pushViewController:browser animated:YES];
            
        }
        
    }];
    
    
    
    //13.评论弹出输入框和键盘
    
    [self.bridge registerHandler:@"addTopicReply" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *content = data[@"replyName"];
        NSString *userId = data[@"id"];
        
        NSString *record =  [NSString stringWithFormat:@"%@",recordId];
        
        if (record.length != 0  ) {
            
            NSLog(@"sss ");
            
           
            if (![record isEqualToString:userId]) {
                
                IFView.TextViewInput.text = nil;
                
            }
        }
        recordId = [NSNumber numberWithInteger:userId.integerValue];
        
//        recordId =userId;
        recrodName = content;
        
        if (content.length ==0) {
            
            IFView.promptContent = @"我也说一句";
            
        }else {
            
            IFView.promptContent= [NSString stringWithFormat:@"回复%@:",content];
            
        }
        [self popUpKeyboard];
        
        
    }];
    
    //14.跳转到商家
    [self.bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        if (data[@"merchantNo"]) {
            
            MerchantDeatilViewController *merchatDetailVC = [[MerchantDeatilViewController alloc]init];
            merchatDetailVC.merchantNo = data[@"merchantNo"];
            [self.navigationController pushViewController:merchatDetailVC animated:YES];
        }
    }];
    
    
    //跳转到新的控制器
    [self.bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *targetUrl = data[@"targetUrl"];
        NSArray *targetUrls = [targetUrl componentsSeparatedByString:@"?"];
        if (targetUrls.count>0) {
            if ([targetUrls[0] isEqualToString:@"zone/cpDetail.html"]||[targetUrls[0] isEqualToString:@"zone/zxDetail.html"]||[targetUrls[0] isEqualToString:@"zone/wzDetail.html"]) {
                H5_DetailViewController *audisVC = [[H5_DetailViewController alloc] init];
                audisVC.H5_DetailID = targetUrl;
                [self.navigationController pushViewController:audisVC animated:YES];
                
                return;
                
            }
        }

        BusinessCircleController *businessVC = [[BusinessCircleController alloc] init];
        businessVC.selfTitle = data[@"targetTitle"];;
        businessVC.requestUrl =data[@"targetUrl"];
        
        [self.navigationController pushViewController:businessVC animated:YES];
        
    }];
     
    if ([self.title isEqualToString:@"商圈"]) {
        
    }else
    {
        
        [self addCustombackButtonItem];
        
    }
}
        


#pragma mark ------进行页面跳转------
-(void)gonoPageJump:(NSNotification *)not
{
    NSString *url;
    
    if ([self.bussinessFrom isEqualToString:@"1"]) {
        url = [NSString stringWithFormat:@"zone/cpDetail.html?id=%@&from=app",self.bussinessID];
        
    }else if ([self.bussinessFrom isEqualToString:@"0"])
    {
        if([self.topicType isEqualToString:@"0"]){
            
//            zone/zxDetail.html?id=id&from=app
            url = [NSString stringWithFormat:@"zone/zxDetail.html?id=%@&from=app",self.bussinessID];
            
        }else if([self.topicType isEqualToString:@"1"]){
            
            url = [NSString stringWithFormat:@"zone/cpDetail.html?id=%@&from=app",self.bussinessID];
        }
    }
    
    if (url.length != 0) {
        
        NSLog(@"%@==ddd",[not userInfo]);
        NSString *from = [[not userInfo] objectForKey:@"isback"];
        if (![from intValue]) {
            H5_DetailViewController *detailVC = [[H5_DetailViewController alloc]init];
            detailVC.H5_DetailID = url;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    };

}


///**
// *  test 测试
// */
//- (void)goPhoto
//{
//    [self registerForKeyboardNotifications];
//
//    [IFView showKeyBoardhiddenAdd:YES];
//
//}


/**
 *  调用键盘
 */
-(void)popUpKeyboard
{
    [self registerForKeyboardNotifications];
    
    [IFView showKeyBoardhiddenAdd:YES];
    
}


//注册键盘通知
- (void) registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//键盘的弹出方法
- (void) keyboardWillShow:(NSNotification *) notification
{
    
    
    IFView.hidden = NO;
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGRect frame = IFView.frame;//CGRectMake(0, Main_Screen_Height - 50 -keyboardBounds.size.height-64, Main_Screen_Width, 50);
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height -keyboardBounds.size.height-64;
    IFView.frame = frame;
    
    [UIView commitAnimations];
    
    
    //    NSLog(@"keyBoard:%f", keyboardSize.height);//216
    ///keyboardWasShown = YES;
}
- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    
    
    CGRect frame = IFView.frame;//CGRectMake(0, Main_Screen_Height - 50-64 , Main_Screen_Width, 50);
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height - 64;
    IFView.frame = frame;
    IFView.hidden = YES;

}


/**
 *  发布信息
 *
 *  @param type 发布类型
 */
- (void)goUpLoadPhotosViewControllerReleaseType:(NSString *)type
{
//    UpLoadPhotosViewController *upVC = [[UpLoadPhotosViewController alloc] init];
//
//    upVC.releaseType = type;
//    
//    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//    
//    [self.navigationController pushViewController:upVC animated:YES];
    
}

#pragma mark -UUInputFunctionViewDelegate

// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    if (message.length ==0) {
        return;
        
    }
    if (message.length >=140) {
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"提示" withTitleClor:nil message:@"输入内容不得超过140个字" withMessageColor:nil oKButtonTitle:nil withOkButtonColor:nil cancelButtonTitle:@"确定" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        [alert show];
        return;
    }
    
    
    [IFView showKeyBoardhiddenAdd:YES];
    [self handleSingleTap:nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"contOut":message} options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    /**********************************/
    [self.bridge callHandler:@"getMsgFromNative" data:json];
    /**********************************/
    
    //!发送成功以后，把信息置空
    IFView.TextViewInput.text = nil;
    
    
}

// image

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image withUrl:(NSString *)url
{
    
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)destructionSelfVC
{
    [self.rdv_tabBarController setSelectedIndex:self.rdv_tabBarController.lastSelectedIndex];
    
}
/**
 *  点击商圈收图
 */
- (void)clickPhotoJumpOtherVC
{
    
}

//-  (BOOL)stringContainsEmoji:(NSString *)string
//{
//    __block BOOL returnValue = NO;
//    
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//    
//    return returnValue;
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DebugLog(@"点我了");
    
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [super webViewProgress:webViewProgress updateProgress:progress];
    
    [self.progressView setProgress:progress animated:YES];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
    
}
- (void)loadFailedAgainRequest
{
    [super loadFailedAgainRequest];
    
    if (self.selfTitle != nil &&self.requestUrl!=nil) {
        self.title = self.selfTitle;
        [HttpManager businessCircleRequestWebView:self.webView requestUrl:self.requestUrl];
        //叮咚官方
        if ([self.requestUrl isEqualToString:@"zone/ddopIndex.html"]) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
        }
        NSString *titleStr = self.requestUrl;
        NSArray *htmlArr = [titleStr componentsSeparatedByString:@"?"];
        //        if (htmlArr.count>1) {
        if ([htmlArr[0] isEqualToString:@"zone/sellerIndex.html"]) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
            
            //            }
        }
        
    }else
    {
        [HttpManager businessCircleRequestWebView:self.webView];
        self.title = @"商圈";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
