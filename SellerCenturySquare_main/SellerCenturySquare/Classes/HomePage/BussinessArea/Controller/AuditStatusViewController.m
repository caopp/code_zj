//
//  AuditStatusViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/12/29.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "AuditStatusViewController.h"
#import "BussinessAreaController.h"
#import "MWPhotoBrowser.h"
#import "UUInputFunctionView.h"
#import "GUAAlertView.h"
#import "Masonry.h"
// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
@interface AuditStatusViewController ()<MWPhotoBrowserDelegate,UIGestureRecognizerDelegate,UUInputFunctionViewDelegate>
{
    MWPhotoBrowser *browser;
    //自定义键盘
    UUInputFunctionView *IFView;
    
    //记录文章id做对比
    NSNumber *recordId;
    NSString *recrodName;


}

@property (nonatomic ,strong) NSMutableArray *photos;


@end

@implementation AuditStatusViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
//    self.navigationItem.leftBarButtonItem =    [self barButtonWithtTitle:@"HAH" font:[UIFont systemFontOfSize:15]];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    //请求webVeiw
    [HttpManager AuditStatusRequestWebView:self.webView requestUrl:self.requestUrl];
    
    //初始化页面设置
    [self setMarkUI];
    
    //JS交互
    [self JSInterAction];

}

//初始化页面设置
- (void)setMarkUI
{
    //设置返回按钮
    [self customBackBarButton];
    
    //设置位置及大小
//    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];

    
    //允许交互
    self.webView.userInteractionEnabled = YES;
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    swipeGesture.delegate =self;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:swipeGesture];
    
    //吊起的键盘
    IFView = [[UUInputFunctionView alloc]
              initWithSuperVC:self withIsCustomerConversation:NO];
    
    IFView.delegate = self;
    
    [self.view addSubview:IFView];
    IFView.hidden = YES;
    
}

//与JS交互
- (void)JSInterAction
{
    
    // showBigPic12.预览图片
    
    [self.bridge registerHandler:@"showBigPic" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        
        NSString *urlStr = data[@"imgUrls"] ;
        NSString *str = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *urlArr = [str componentsSeparatedByString:@","];
        NSString *position = data[@"position"];
        
        NSString *from = data[@"from"];
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
    
    
    
    
    //13.评论弹出输入框和键盘
    
    [self.bridge registerHandler:@"addTopicReply" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *content = data[@"replyName"];
        NSString *userId = data[@"id"];
        
        NSString *record = [NSString stringWithFormat:@"%@",recordId];
        
        if (record.length != 0  ) {
            if (![record isEqualToString:userId]) {
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



#pragma mark - Action


//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller  isKindOfClass:[BussinessAreaController class]]) {
            BussinessAreaController *bussinessVC = (BussinessAreaController*)controller;
            NSArray *targetUrls = [bussinessVC.rightItemUrl componentsSeparatedByString:@"?"];
            NSLog(@"%@",bussinessVC.rightItemUrl);
            
            
            if ([bussinessVC.makrRightNav isEqualToString:@"right"]) {
                [self.navigationController popToViewController:bussinessVC animated:YES];
                return;
                
            }
        }
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller  isKindOfClass:[BussinessAreaController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            
        }
    }
    
}



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
                                             selector:@selector(keyboardWillShow1:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide1:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


//键盘的弹出方法
- (void) keyboardWillShow1:(NSNotification *) notification
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
    
//    CGRect frame = CGRectMake(0, Main_Screen_Height - 50-64 - keyboardBounds.size.height, Main_Screen_Width, 50);
//    IFView.frame = frame;
    
    
    CGRect frame = IFView.frame;
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height -keyboardBounds.size.height-64;
    IFView.frame = frame;
    
    [UIView commitAnimations];
    
    
}

- (void) keyboardWillHide1:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect keyboardBounds;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
//    CGRect frame = CGRectMake(0, Main_Screen_Height - 50 - 64 , Main_Screen_Width, 50);
//    
//    IFView.frame = frame;
    CGRect frame = IFView.frame;
    frame.origin.y = Main_Screen_Height - IFView.frame.size.height - 64;
    IFView.frame = frame;

    
    IFView.hidden = YES;
    
}

/**
 *  点击空白出收回键盘
 */
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    if (!IFView.hidden) {
        
        [IFView showKeyBoardhiddenAdd:NO];
        
    }
}


/**
 *  重写父类方法 跳转到H5主页
 */
- (void)destructionSelfVC
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BussinessAreaController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    
}






#pragma mark - -----进行页面跳转------Notification
-(void)gonoPageJump:(NSNotification *)not
{
    
    NSLog(@"%@==ddd",[not userInfo]);
    NSString *from = [[not userInfo] objectForKey:@"isback"];
    if ([from intValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}





#pragma mark -UUInputFunctionViewDelegate

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
    IFView.TextViewInput.text = nil;


    
}

// image

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image withUrl:(NSString *)url
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webViewDelegate
//在webView 上必须添加
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}


#pragma mark - MWPhotoBrowserDelegate
//

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


#pragma mark - LoadFailedDelegate

//点击重新加载 执行此方法。
- (void)loadFailedAgainRequest
{
    [super loadFailedAgainRequest];
    [HttpManager AuditStatusRequestWebView:self.webView requestUrl:self.requestUrl];

}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ddopImgNotification" object:nil];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
