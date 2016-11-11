//
//  BussinessAreaController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/16.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BussinessAreaController.h"

#import "UpLoadPhotosViewController.h"
#import "HttpManager.h"

#import "BaseJSViewController.h"//基类
#import "ACMacros.h"
#import "UUInputFunctionView.h"
#import "GUAAlertView.h"
#import "MWPhotoBrowser.h"
#import "AuditStatusViewController.h"
#import "Masonry.h"


@interface BussinessAreaController ()<UUInputFunctionViewDelegate,UIGestureRecognizerDelegate ,MWPhotoBrowserDelegate,UpLoadPhotosDelegate ,UIWebViewDelegate>
{
    //自定义键盘
    UUInputFunctionView *IFView;
    
    //记录文章id做对比
    NSNumber *recordId;
    //
    NSString *recrodName;
    MWPhotoBrowser *browser;
}

//请求的ULR
@property (nonatomic ,strong)NSString *requestURL;
@property (nonatomic ,strong)NSMutableArray *photos;

//文章ID
@property (nonatomic,strong) NSString *bussinessID;
//0 从首页; 1从详情页
@property (nonatomic,strong) NSString *bussinessFrom;

@property (nonatomic ,strong) NSString *topicType;
//是否显示引导图
@property (nonatomic ,strong) NSString *mark;


@property (nonatomic ,assign)BOOL isLoading;


@end

@implementation BussinessAreaController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.hidden = NO;

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];


    
    //调用请求h5
    if (!self.isLoading) {
        [HttpManager businessCircleHomeRequestWebView:self.webView];
        self.isLoading = YES;
    }

    
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;

     
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
    
    //初始化设置页面
    [self setMarkUI];
    
    //刷新请求WebView
    [self refreshRequestWebView];
    
    //与JS进行交互
    [self jsInterAction];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    
//}
/**
 *  初始化设置
 */
-(void)setMarkUI
{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置返回按钮
    [self customBackBarButton];
    
    //设置位置大小
//    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];

    
    // 允许交互
    self.webView.userInteractionEnabled = YES;
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    swipeGesture.delegate =self;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
    
    
    //吊起的键盘
    IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:NO];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    IFView.hidden = YES;


}


//刷新请求WebView页面

- (void)refreshRequestWebView
{
    
    //点击叮咚官方按钮跳转,判断URL是否有值 进行跳转
    if (self.rightItemUrl!=nil && self.rightItemUrl.length>0) {
        [HttpManager businessCircleHomeRequestWebView:self.webView withRequesUrl:self.rightItemUrl];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
        
        self.isLoading = YES;
        
        
    }
    
    //重复跳转本类。有值就跳转
    if (self.requestURL !=nil && self.requestURL.length>0) {
        [HttpManager businessCircleHomeRequestWebView:self.webView withRequesUrl:self.requestURL];
        self.isLoading = YES;
        
    }
    

}


//与JS进行交互
- (void)jsInterAction
{
    //11.发布资讯或测评
    [self.bridge registerHandler:@"addTopicInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        
        if ([data[@"topicType"] isEqualToString:@"1"]) {
            [self goUpLoadPhotosViewControllerReleaseType:@"1"];
            
            if ([data[@"mark"] isEqualToString:@"0"]) {
                //为0 显示
                self.mark = @"show";
                
            }else if ([data[@"mark"] isEqualToString:@"1"])
            {
                //为1 不显示
                self.mark = @"hide";
                
            }else
            {
                //默认显示
                self.mark = @"show";
            }
            

          
            
        }else if ([data[@"topicType"] isEqualToString:@"0"])
        {
            [self goUpLoadPhotosViewControllerReleaseType:@"0"];
            
        }
        
    }];
    
    
    
    
#pragma mark  openNewPage 商圈顶部状态导航栏与JS交互
    [self.bridge registerHandler:@"openNewPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSString *targetUrl = data[@"targetUrl"];
        NSArray *targetUrls = [targetUrl componentsSeparatedByString:@"?"];
        if (targetUrls.count>0) {
            if ([targetUrls[0] isEqualToString:@"zone/cpDetail.html"]||[targetUrls[0] isEqualToString:@"zone/zxDetail.html"]||[targetUrls[0] isEqualToString:@"zone/wzDetail.html"]) {
                AuditStatusViewController *audisVC = [[AuditStatusViewController alloc] init];
                audisVC.requestUrl = targetUrl;
                [self.navigationController pushViewController:audisVC animated:YES];
                
                return;
                
            }
        }
        BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
        bussinessVC.requestURL = data[@"targetUrl"];
        bussinessVC.selfTitle = data[@"targetTitle"];
        
        [self.navigationController pushViewController:bussinessVC animated:YES];
        
    }];
    
    //    showBigPic12.预览图片
    
    [self.bridge registerHandler:@"showBigPic" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *dict = data;
        NSString *urlStr = data[@"imgUrls"] ;
        NSString *str = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *urlArr = [str componentsSeparatedByString:@","];
        NSString *position = data[@"position"];
        
        NSString *from = data[@"from"];
        NSString *uiD = data[@"id"];
        NSString *topicType = data[@"topicType"];
        self.topicType = topicType;
        
        
        //0 从首页; 1从详情页∆
        self.bussinessFrom = from;
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
                if (url.length != 0){
                    photo  = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
                    [photos addObject:photo];
                }
            }
            
            self.photos    = photos;
            // Create browser
            browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = YES;
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
    
    
    
    
    
#pragma mark 设置原生导航栏的title(setNavBarTitle)
    [self.bridge  registerHandler:@"setNavbarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.title = data[@"targetTitle"];
        //                BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
        self.rightItemTitle = data[@"rightTitle"];
        self.rightItemUrl = data[@"rightTitleUrl"];
        
        if (self.rightItemTitle != nil && self.rightItemTitle.length>0) {
            
            UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithTitle:self.rightItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(clickNavRightBtn)];
            
            //            UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
            
            self.navigationItem.rightBarButtonItem = backBarButton;
            
            if ([self.rightItemUrl isEqualToString:@"zone/ddopIndex.html"]) {
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
                
            }
            
            
        }
        
        //                [self.navigationController pushViewController:bussinessVC animated:YES];
        
    }];
    
    
    
    
    
    //13.评论弹出输入框和键盘
    
    [self.bridge registerHandler:@"addTopicReply" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *content = data[@"replyName"];
        NSString *userId = data[@"id"];
        
        NSString *record = [NSString stringWithFormat:@"%@",recordId];
        
        if (record.length != 0  ) {
            if (![record isEqualToString:[NSString stringWithFormat:@"%@",userId]]) {
                IFView.TextViewInput.text = nil;
                
            }
        }
        
        recordId = [NSNumber numberWithInteger:userId.integerValue];
        recrodName = content;
        
        if (content.length ==0) {
            
            IFView.promptContent = @"评论，最多140字~";
            
        }else {
            
            IFView.promptContent= [NSString stringWithFormat:@"回复%@:",content];
            
        }
        [self popUpKeyboard];
        
        
    }];

}


-(void)deleteCookieForDominPathStr:(NSString *)thePathz
{
    
}

#pragma mark - -----进行页面跳转------NSNotification
-(void)gonoPageJump:(NSNotification *)not
{
    NSString *url;
    
//
        if ([self.bussinessFrom isEqualToString:@"1"]) {
            url = [NSString stringWithFormat:@"zone/cpDetail.html?id=%@&from=app",self.bussinessID];
            
        }else if ([self.bussinessFrom isEqualToString:@"0"])
        {
            
            if([self.topicType isEqualToString:@"0"]){
                //资讯详情和测评详情
                
                //资讯详情
                url = [NSString stringWithFormat:@"zone/zxDetail.html?id=%@&from=app",self.bussinessID];

            }else if([self.topicType isEqualToString:@"1"]){
                
                //测评详情
                url = [NSString stringWithFormat:@"zone/cpDetail.html?id=%@&from=app",self.bussinessID];
            }

            
        }
        
        if (url.length != 0) {
            AuditStatusViewController *auditVC = [[AuditStatusViewController alloc] init];
            
            auditVC.requestUrl = url;
            
            [self.navigationController pushViewController:auditVC animated:YES];
            
        }
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
    
    
//    CGRect frame = CGRectMake(0, Main_Screen_Height - 50 -64-keyboardBounds.size.height, Main_Screen_Width, 50);
//    IFView.frame = frame;
    
    CGRect frame = IFView.frame;
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height -keyboardBounds.size.height-64;
    IFView.frame = frame;
    [UIView commitAnimations];


//    NSLog(@"keyBoard:%f", keyboardSize.height);//216
    ///keyboardWasShown = YES;
}

//键盘将要消失的时候
- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
//    CGRect frame = CGRectMake(0, Main_Screen_Height - 50-64 , Main_Screen_Width, 50);
//    IFView.frame = frame;
    
    CGRect frame = IFView.frame;
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height - 64;
    IFView.frame = frame;
   IFView.hidden = YES;

}


#pragma mark - Action

/**
 *  发布信息
 *
 *  @param type 发布类型
 */
- (void)goUpLoadPhotosViewControllerReleaseType:(NSString *)type
{
    UpLoadPhotosViewController *upVC = [[UpLoadPhotosViewController alloc] init];
    
    upVC.releaseType = type;
    upVC.delegate = self;
    upVC.mark = self.mark;
    
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [self.navigationController pushViewController:upVC animated:YES];
    
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
/**
 *  点击空白出收回键盘
 */
-(void)handleSingleTap:(UISwipeGestureRecognizer *)sender

{
    
    if (!IFView.hidden) {
        
        [IFView showKeyBoardhiddenAdd:NO];
        
    }
    
}




/**
 *  调用键盘
 */
-(void)popUpKeyboard
{
    [self registerForKeyboardNotifications];
    
    [IFView showKeyBoardhiddenAdd:YES];
//    recrodName = nil;
//    recordId = nil;
    
    
}




/**
 *  点击叮咚官方按钮跳转
 */
- (void)clickNavRightBtn
{
    if (self.rightItemUrl!=nil &&self.rightItemUrl.length>0) {
        BussinessAreaController *bussinessVC = [[BussinessAreaController alloc] init];
        bussinessVC.rightItemUrl = self.rightItemUrl;
        //标记此类的为叮咚官方
        bussinessVC.makrRightNav = @"right";
        //添加通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
        self.isLoading = NO;
        [self.navigationController pushViewController:bussinessVC animated:YES];
        
    }
}
#pragma mark -UUInputFunctionViewDelegate

// text
//键盘输入的字体内容
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
    
    ;
    /**********************************/

    //!发送给h5之后，清空输入的内容
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

#pragma mark - webViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [super webView:webView didFailLoadWithError:error];
    self.isLoading = NO;
}


//在webView 上必须添加
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}


#pragma mark - 父类的代理方法LoadFailedViewdelegate
//加载失败点击重新加载
- (void)loadFailedAgainRequest
{
    [super loadFailedAgainRequest];
    //首页
    if (!self.isLoading) {
        [HttpManager businessCircleHomeRequestWebView:self.webView];
        self.isLoading = YES;
        
    }
    
    //叮咚官方页面
    if (self.rightItemUrl!=nil && self.rightItemUrl.length>0) {
        [HttpManager businessCircleHomeRequestWebView:self.webView withRequesUrl:self.rightItemUrl];
        self.isLoading = YES;
        
        
    }
    
    //其他本类的页面
    if (self.requestURL !=nil && self.requestURL.length>0) {
        [HttpManager businessCircleHomeRequestWebView:self.webView withRequesUrl:self.requestURL];
        self.isLoading = YES;
    }
}



/**
 *  点击商圈收图
 */
- (void)clickPhotoJumpOtherVC
{
    

}




#pragma mark - UpLoadPhotosDelegate
//发布资讯/测评成功以后 此方法能用于刷新页面
- (void)UpLoadPhotosLoading:(BOOL)isLoading
{
    self.isLoading = isLoading;
}

//暂无用处
- (void)UpLoadPhotosUrl:(NSString *)url
{
    [HttpManager AuditStatusRequestWebView:self.webView requestUrl:url];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImgNotification" object:nil];
}





@end
