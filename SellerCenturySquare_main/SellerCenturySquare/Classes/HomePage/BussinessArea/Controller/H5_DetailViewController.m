//
//  H5_DetailViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/12/31.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "H5_DetailViewController.h"
#import "HttpManager.h"
#import "BaseJSViewController.h"
#import "UUInputFunctionView.h"
#import "MWPhotoBrowser.h"
#import "GUAAlertView.h"
#import "BussinessAreaController.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
@interface H5_DetailViewController ()<UUInputFunctionViewDelegate,UIGestureRecognizerDelegate>
{
    UUInputFunctionView *IFView;
    NSString *recordId;
    NSString *recrodName;
    MWPhotoBrowser *browser;

}
@property (nonatomic ,strong)NSMutableArray *photos;

@end

@implementation H5_DetailViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//        self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;


}

//在webView 上必须添加
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
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



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self customBackBarButton];

    
    [HttpManager AuditStatusRequestWebView:self.webView auditStatusID:self.H5_DetailID];
    
    
    self.webView.userInteractionEnabled = YES;
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    tap.delegate =self;
//    
//    [self.view addGestureRecognizer:tap];

    
    
    //1.销毁当前页面
    [self.bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self destructionSelfVC];
        
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gonoPageJump:) name:@"ImgNotification" object:nil];
    //11.发布资讯或测评
    [self.bridge registerHandler:@"addTopicInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        //吊起的键盘
        IFView = [[UUInputFunctionView alloc] initWithSuperVC:self withIsCustomerConversation:NO];
        
        IFView.delegate = self;
        
        [self.view addSubview:IFView];
        IFView.hidden = YES;

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
        
        
        if (urlArr.count > 0) {
            
            for (NSString *url in urlArr) {
                
                photo  = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
            
                [photos addObject:photo];
                
            }
            
            self.photos    = photos;
            // Create browser
            browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = NO;
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
        
        if (recordId.length != 0  ) {
            if (![recordId isEqualToString:userId]) {
                IFView.TextViewInput.text = @"";
                
            }
        }
        
        recordId =userId;
        recrodName = content;
        
        if (content.length == 0) {
            IFView.promptContent = @"评论，最多140字~";
            
            
        }else {
            IFView.promptContent= [NSString stringWithFormat:@"回复%@:",content];
            
        }
        [self popUpKeyboard];
    
    }];

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

#pragma mark ------进行页面跳转------
-(void)gonoPageJump:(NSNotification *)not
{
    
    NSLog(@"%@==ddd",[not userInfo]);
    NSString *from = [[not userInfo] objectForKey:@"isback"];
    if ([from intValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
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
    
    CGRect frame = CGRectMake(0, Main_Screen_Height - 50 - keyboardBounds.size.height, Main_Screen_Width, 50);
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
    
    CGRect frame = CGRectMake(0, Main_Screen_Height - 50 - 64 , Main_Screen_Width, 50);
    
    IFView.frame = frame;
    
    IFView.hidden = YES;
    
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




/**
 *  点击商圈收图
 */
- (void)clickPhotoJumpOtherVC
{
    
    
}

//返回按钮执行事件
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller  isKindOfClass:[BussinessAreaController class]]) {
            BussinessAreaController *bussinessVC = (BussinessAreaController*)controller;
            if ([bussinessVC.requestUrl isEqualToString:@"zone/ddopIndex.html"]) {
            [self.navigationController popToViewController:controller animated:YES];
                return;
            }
         
        }
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller  isKindOfClass:[BussinessAreaController class]]) {
            BussinessAreaController *bussinessVC = (BussinessAreaController*)controller;
            [self.navigationController popToViewController:controller animated:YES];
            
        }
    }
    
    
}

- (void)destructionSelfVC
{
    NSArray * vcArray = [self.navigationController childViewControllers];
    
    [self.navigationController popToViewController:vcArray[1] animated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
